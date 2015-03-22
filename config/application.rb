require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NiuNiu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :"zh-CN"
    
    config.autoload_paths += %W(#{Rails.root}/app/models/errors)
    
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
    
    config.assets.enabled = true
    config.assets.version = '1.0'
    
    config.assets.precompile += [Proc.new { |path| File.basename(path) =~ /^[^_][a-z0-9-]+\.css$/ }]

    config.assets.precompile << Proc.new do |path|
       if path =~ /\.(css|js|scss|png|jpg|gif|json)\z/
         full_path = Rails.application.assets.resolve(path).to_path
        app_assets_path = Rails.root.join('app', 'assets').to_path
        if full_path.starts_with? app_assets_path
          puts "including asset: " + full_path
          true
        else
          puts "excluding asset: " + full_path
          false
        end
      else
        false
      end
    end
    
  end
end


