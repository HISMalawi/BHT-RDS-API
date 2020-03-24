# frozen_string_literal: true

require 'logger'

namespace :app do
  LOGGER = Logger.new(STDOUT)
  # SQL Scripts for database setup
  SQL_SCRIPTS = [
    'openmrs_1.7.0_schema.sql',
    'openmrs_metadata_1_7.sql'
  ].freeze

  task :setup do
    # LOGGER.warn('This action will clobber your database, Are you sure you want to continue: Y/N [N]> ')
    # while (reply = STDIN.gets.strip)
    #   exit(0) if reply.blank? || reply.match?(/(N|No)/i)

    #   break if reply.match?(/(Y|Yes)/i)

    #   LOGGER.error('Invalid response: Y/N [N]> ')
    # end

    next if system('rails db:drop db:create app:db_setup db:migrate app:clear_log')

    LOGGER.error('Failed to setup database, please check your database configuration')
    exit(1)
  end

  task :db_setup do
    SQL_SCRIPTS.each do |script|
      LOGGER.info("Loading #{script}")

      LOGGER.debug(mysql_load_script_command(script))
      next if system(mysql_load_script_command(script))

      LOGGER.error("Failed to load SQL script `#{script}`, please check your database configuration")
      exit(1)
    end
  end

  task :clear_log do
    LOGGER.info('Deleting last_seq file...')
    File.unlink(Rails.root.join('log/rds_last_seq.yml'))
  rescue Errno::ENOENT => e
    LOGGER.warn("Failed to delete last_seq file: #{e}")
  end

  def mysql_load_script_command(script)
    script_path = Rails.root.join("db/sql/#{script}")

    username = db_config['username']
    password = db_config['password']
    database = db_config['database']
    host     = db_config['host']

    "PGPASSWORD=#{password} psql -h #{host} -U #{username} #{database} < #{script_path}"
  end

  def db_config
    @db_config ||= YAML.load_file(Rails.root.join('config/database.yml'))[ENV['RAILS_ENV'] || 'development']
  end
end
