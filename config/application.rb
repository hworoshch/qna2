require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.action_cable.disable_request_forgery_protection = false

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_specs: true
    end

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }
  end
end
