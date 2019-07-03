# frozen_string_literal: true

require 'logger'
require 'rest-client'
require 'securerandom'

MAX_COUCH_UPDATES_FETCHED = 5000 # Maximum updates that can be fetched per request

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO

class CouchSyncService
  def load_updates
    ActiveRecord::Base.connection.execute('SET foreign_key_checks=0')

    couch_updates.each do |update|
      doc_id, doc_type, doc = parse_couch_doc(update)

      model = doc_type.constantize

      # HACK: Remap conflicting uuids for the following 3 tables. These tables are
      # preloaded with static metadata for users including uuids thus different
      # sites have the same user with the same UUID.
      if [User, Person, PersonName].include?(model) && model.where(uuid: doc['uuid']).exists?
        LOGGER.debug("Remapping conflicting UUID (#{doc['uuid']}) for #{model}")
        old_uuid = doc['uuid']
        doc['uuid'] = SecureRandom.uuid
        UUIDRemap.create(record_type: model.to_s, record_id: doc[model.primary_key.to_s],
                         old_uuid: old_uuid, new_uuid: doc['uuid'])
      end

      record = model.find_by("#{model.primary_key} = ?", doc[model.primary_key])
      record = record ? record.update(doc.tap { |doc| doc[:updated_at] = Time.now }) && record : model.create(doc)

      if record.errors.empty?
        LOGGER.info("Successfully saved #{model}(#{doc_id} => ##{record.id})")
      else
        LOGGER.error("Error loading #{model}(#{doc_id}): #{doc} due to:\n\t#{record.errors.to_json} ~ #{doc}")
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
