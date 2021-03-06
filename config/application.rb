require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
require "action_view/railtie"
require "sprockets/railtie"
require 'sprockets/es6'
require 'money'
require 'money/bank/google_currency'
require 'sidekiq/web'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Foodxervices
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    require 'string'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Singapore'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    config.active_job.queue_adapter = :sidekiq

    Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
      [user, password] == ["admin", "123123a1@"]
    end

    WillPaginate.per_page = 16
    Money::Bank::GoogleCurrency.ttl_in_seconds = 86400
    Money.default_bank = Money::Bank::GoogleCurrency.new

    config.upload_file_type = [
                    /\Aimage\/.*\Z/,
                    "application/pdf"
                  ]
  end
end
