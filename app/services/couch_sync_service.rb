# frozen_string_literal: true

require 'logger'
require 'rest-client'

class CouchSyncService
  LOGGER = Logger.new(STDOUT)

  def load_updates
    fetch_updates.each_with_object([]) do |update, records|
      model = update.delete('record_type').constantize
      record = model.find_by("#{model.primary_key} = ?", update[model.primary_key])
      record&.update(update)

      record ||= model.create(update)

      unless record.errors.empty?
        LOGGER.error("Error loading #{model}#{record.as_json} due to: #{record.errors.to_json}")
        next
      end

      records << record
    end
  end

  private

  def fetch_updates
    last_seq = load_last_seq

    response = handle_response do
      url = "#{couch_databse_url}/_changes"
      url = "#{url}?last_seq=#{last_seq}" if last_seq
      # TODO: mod url to include last_seq if available
      LOGGER.debug("Fetching changes from: #{url}")
      RestClient.get(url)
    end

    save_last_seq(response['last_seq'])

    transform_updates_to_docs(response['results'])
  end

  def couch_databse_url
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

  def transform_updates_to_docs(updates)
    Enumerator.new do |enum|
      updates.each do |update|
        document = handle_response do
          url = "#{couch_databse_url}/#{update['id']}"
          LOGGER.debug("Fetching document: #{url}")
          RestClient.get(url)
        end

        enum.yield(decouchify_document!(document))
      end
    end
  end

  # Removes CouchDB autogenerated fields (ie _id and _rev)
  def decouchify_document!(document)
    LOGGER.debug("Decouchifying #{document['record_type']}(#{document['_id']})")
    document.delete('_id')
    document.delete('_rev')
    document
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
