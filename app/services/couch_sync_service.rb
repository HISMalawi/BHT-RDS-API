# frozen_string_literal: true

require 'logger'
require 'rest-client'
require 'securerandom'

MAX_COUCH_UPDATES_FETCHED = 5000 # Maximum updates that can be fetched per request

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO
# ActiveRecord::Base.logger = LOGGER

class CouchSyncService
  class CouchSyncServiceError < StandardError; end

  def load_updates
    ActiveRecord::Base.connection.execute('SET foreign_key_checks=0')

    couch_updates.each do |update|
      doc_id, doc_type, doc = parse_couch_doc(update)

      begin
        model = model_from_doc_type(doc_type)

        # HACK: Remap conflicting uuids. Most tables are preloaded with static
        # metadata for users (and other entities) including uuids thus different
        # sites have the same entities with the same UUID.
        remap_model_uuid(model, doc) if model_uuid_exists(model, doc)

        record = update_or_create_record(model, doc)
        if record.errors.empty?
          LOGGER.info("Successfully saved #{model}(#{doc_id} => ##{record.id})")
        else
          LOGGER.error("Failed to save #{model}(#{doc}) due to #{record.as_json}")
          log_model_error(model, doc_id, doc, exception: nil,
                                              message: 'Could not save record',
                                              model_errors: record.errors.as_json)
        end
      # rescue CouchSyncServiceError, ActiveRecord::ActiveRecordError => e
      rescue StandardError => e
        LOGGER.error("Failed to save #{model}(#{doc}) due to #{e}")
        log_model_error(model, doc_id, doc, exception: e.class.to_s, message: e.message)
      end
    end

    ActiveRecord::Base.connection.execute('SET foreign_key_checks=1')
  end

  private

  def couch_updates
    Enumerator.new do |enum|
      loop do
        changes, last_seq = read_couch_changes

        break if changes.empty?

        changes.each do |change|
          enum.yield(fetch_couch_doc(change['id']))
        end

        save_last_seq(last_seq)
      end
    end
  end

  def model_from_doc_type(doc_type)
    doc_type.constantize
  rescue NameError
    raise CouchSyncServiceError, "Invalid model type: #{doc_type}"
  end

  def update_or_create_record(model, data)
    LOGGER.debug("Creating record #{model}(#{data})")
    record = model.find_by("#{model.primary_key} = ?", data[model.primary_key])

    return model.create(data) unless record

    LOGGER.debug("Record exists: updating #{model}(##{data[model.primary_key]})")
    data['updated_at'] = Time.now
    record.update(data)
    record
  end

  def log_model_error(model, doc_id, record, error)
    File.open(Rails.root.join('log', 'couch-update-errors.log'), 'a') do |log_file|
      log = { doc_id => { 'model' => model.to_s, 'record' => record, 'error' => error } }
      LOGGER.debug("Logging error to log file: #{log}")
      log_file.write(log.to_yaml)
    end
  end

  def model_uuid_exists(model, doc)
    model.column_names.include?('uuid') && model.unscoped.where(uuid: doc['uuid']).exists?
  end

  def remap_model_uuid(model, doc)
    LOGGER.debug("Remapping conflicting UUID (#{doc['uuid']}) for #{model}")
    old_uuid = doc['uuid']
    doc['uuid'] = SecureRandom.uuid
    UUIDRemap.create(record_type: model.to_s, record_id: doc[model.primary_key.to_s],
                     old_uuid: old_uuid, new_uuid: doc['uuid'])
  end

  def parse_couch_doc(couch_doc)
    doc = couch_doc.dup
    doc_id = doc.delete('_id')
    doc_type = doc.delete('record_type')
    doc.delete('_rev') # Don't need this field
    [doc_id, doc_type, doc]
  end

  def read_couch_changes
    last_seq = load_last_seq

    response = handle_response do
      url = "#{couch_database_url}/_changes?limit=#{MAX_COUCH_UPDATES_FETCHED}"
      url = "#{url}&since=#{last_seq}" if last_seq
      LOGGER.debug("Fetching changes from: #{url}")
      RestClient.get(url)
    end

    [response['results'], response['last_seq']]
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

  def fetch_couch_doc(doc_id)
    handle_response do
      url = "#{couch_database_url}/#{doc_id}"
      LOGGER.debug("Fetching document: #{url}")
      RestClient.get(url)
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
