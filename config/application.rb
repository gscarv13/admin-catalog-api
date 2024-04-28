# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
# require "action_mailer/railtie"
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

require 'debug'

require 'active_record/connection_adapters/sqlite3_adapter'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AdminCatalogApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Add @core at autoload path
    config.autoload_paths << "#{config.root}/core/shared"
    config.autoload_paths << "#{config.root}/core/category"
    config.autoload_paths << "#{config.root}/core/genre"
    config.autoload_paths << "#{config.root}/core/cast_member"
    config.autoload_paths << "#{config.root}/core/video"

    config.eager_load_paths << "#{config.root}/core/shared"
    config.eager_load_paths << "#{config.root}/core/category"
    config.eager_load_paths << "#{config.root}/core/genre"
    config.autoload_paths << "#{config.root}/core/cast_member"
    config.eager_load_paths << "#{config.root}/core/video"

    # Temporary SQLite workaround
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
