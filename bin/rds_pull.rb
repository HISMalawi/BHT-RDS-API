# frozen_string_literal: true

require 'logger'

LOGGER = Logger.new(STDOUT)

POLL_INTERVAL = 5 # In seconds

def main
  service = CouchSyncService.new

  loop do
    LOGGER.info('Polling updates...')
    service.load_updates
    LOGGER.info("Sleeping for #{POLL_INTERVAL} seconds...")
    sleep(POLL_INTERVAL)
  # rescue StandardError => e
  #   LOGGER.error("Runaway exception caught: #{e.class}")
  #   LOGGER.error(e)
  #   sleep(POLL_INTERVAL)
  end
end

main
