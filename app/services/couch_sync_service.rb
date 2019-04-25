# frozen_string_literal: true

require 'logger'
require 'rest-client'

MAX_COUCH_UPDATES_FETCHED = 5000 # Maximum updates that can be fetched per request
MAX_COUCH_UPDATE_QUEUE_COUNT = 10 # Maximum number of times an update can be (re-)queued

class CouchSyncService
  LOGGER = Logger.new(STDOUT)

  class UpdatesQueue
    def push(doc_id, type, doc, queue_count = 0)
      LOGGER.debug("Queueing #{type}(#{doc_id}, doc: #{doc})")

      CouchUpdate.create(doc_id: doc_id, doc_type: type,
                         doc: doc.to_json, queue_count: queue_count,
                         created_at: Time.now)
    end

    def pop
      update = CouchUpdate.order(Arel.sql('queue_count ASC, created_at DESC')).first
      return nil unless update

      LOGGER.debug("Popped #{update.doc_type}(#{update.doc_id}) from queue")
      update
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

    ActiveRecord::Base.connection.execute('SET foreign_key_checks=0')

    while (update = updates_queue.pop)
      begin
        doc = JSON.parse(update.doc)
        model = update.doc_type.constantize
        record = model.find_by("#{model.primary_key} = ?", doc[model.primary_key])
        record = record ? record.update(doc) && record : model.create(doc)
        if record.errors.empty?
          LOGGER.info("Successfully saved #{model}(#{update.doc_id} => ##{record.id})")
          update.destroy
        else
          LOGGER.error("Error loading #{model}(#{update.doc_id}) due to:\n\t#{record.errors.to_json} ~ #{update.doc}")
          update.queue_count += 1
          update.created_at = Time.now
          update.save
        end
      rescue StandardError => e
        LOGGER.error("Error loading #{update.doc_type}(#{update.doc_id}):")
        LOGGER.error(e)
        update.queue_count += 1
        update.created_at = Time.now
        update.save
      end
    end

    ActiveRecord::Base.connection.execute('SET foreign_key_checks=1')
  end

  private

  def fetch_updates
    loop do
      last_seq = load_last_seq

      response = handle_response do
        url = "#{couch_database_url}/_changes?limit=#{MAX_COUCH_UPDATES_FETCHED}"
        url = "#{url}&since=#{last_seq}" if last_seq
        LOGGER.debug("Fetching changes from: #{url}")
        RestClient.get(url)
      end

      save_last_seq(response['last_seq'])

      results = response['results']

      break if results.empty?

      queue_updates(results)
    end
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
      file.write({ 'last_seq' => last_seq }.to_yaml)
    end
  end
end
