require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'aws-sdk'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Phaph
  class Application < Rails::Application

    config.x.app_name = 'Phaph'
    
    api = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
    # AWS::S3::Base.establish_connection!(
    #   :access_key_id => API['aws']['key'],
    #   :secret_access_key => API['aws']['secret']
    # )
    AWS.config(:access_key_id => api['aws']['key'], :secret_access_key => api['aws']['secret'])

    # :persistent        => true, # from http://www.ruby-forum.com/topic/110842

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = "Pacific Time (US & Canada)"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.active_job.queue_adapter = :inline

  end
end
