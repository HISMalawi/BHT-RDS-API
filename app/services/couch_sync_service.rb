# frozen_string_literal: true

require 'logger'
require 'rest-client'

class CouchSyncService
  LOGGER = Logger.new(STDOUT)

  class UpdatesQueue
    def push(doc_id, type, doc)
      LOGGER.debug("Queueing #{type}(#{doc_id}, doc: #{doc})")

      CouchUpdate.create(doc_id: doc_id, doc_type: type,
                         doc: doc.to_json, created_at: Time.now)
    end

    def pop
      update = CouchUpdate.order(:created_at).first
      return nil unless update

      update.destroy
      LOGGER.debug("Popped #{update.doc_type}(#{update.doc_id}) from queue")
      [update.doc_id, update.doc_type, JSON.parse(update.doc)]
    end

    def include?(doc_id)
      CouchUpdate.where(doc_id: doc_id).exists?
    end
  end

  def updates_queue
    @updates_queue ||= UpdatesQueue.new
  end

  def load_updates
    fetch_updates # Loads any incoming updates into queue

    while (update = updates_queue.pop)
      puts update
      doc_id, type, doc = update

      begin
        model = type.constantize
        record = model.find_by("#{model.primary_key} = ?", doc[model.primary_key])
        puts "Record: #{record}"
        record = record ? record.update(doc) && record : model.create(doc)
      rescue StandardError => e
        # if e.message.include?('foreign key constraint fails')
        #   updates_queue.push(doc_id, type, doc)
        #   next
        # end

        LOGGER.error(e)
        updates_queue.push(doc_id, type, doc)
        next
      end

      unless record.errors.empty?
        LOGGER.error("Error loading #{model}#{record.as_json} due to: #{record.errors.to_json}")
        updates_queue.push(doc_id, type, doc)
      end
    end
  end

  private

  def fetch_updates
    last_seq = load_last_seq

    response = handle_response do
      url = "#{couch_database_url}/_changes"
      url = "#{url}?last_seq=#{last_seq}" if last_seq
      # TODO: mod url to include last_seq if available
      LOGGER.debug("Fetching changes from: #{url}")
      RestClient.get(url)
    end

    save_last_seq(response['last_seq'])

    queue_updates(response['results'])
  end

  def couch_database_url
    couch_config = config['couchdb']
    protocal = couch_config['protocol']
    username = couch_config['username']
    password = couch_config['password']
    host = couch_config['host']
    port = couch_config['port']
    database = couch_config['database']

    "#{protocal}://#{username}:#{password}@#{host}:#{port}/#{database}"
  end

  def config
    @config ||= YAML.load_file(Rails.root.join('config/application.yml'))
  rescue StandardError => e
    LOGGER.error('Missing configuration file: config/application.yml')
    raise e
  end

  def handle_response
    response = JSON.parse(yield.body)
    response
  end

  def queue_updates(updates)
    updates.each do |update|
      next if updates_queue.include?(update['id'])

      document = handle_response do
        url = "#{couch_database_url}/#{update['id']}"
        LOGGER.debug("Fetching document: #{url}")
        RestClient.get(url)
      end

      document.delete('_rev')
      doc_id = document.delete('_id')
      type = document.delete('record_type')

      updates_queue.push(doc_id, type, document)
    end
  end

  LAST_SEQ_FILE_PATH = Rails.root.join('log/rds_last_seq.yml')

  def load_last_seq
    YAML.load_file(LAST_SEQ_FILE_PATH)['last_seq']
  rescue Errno::ENOENT => e
    LOGGER.warn("Could not load last seq file: #{e}")
    nil
  end

  def save_last_seq(last_seq)
    File.open(LAST_SEQ_FILE_PATH, 'w') do |file|
      file.write({ last_seq: last_seq }.to_yaml)
    end
  end
end
