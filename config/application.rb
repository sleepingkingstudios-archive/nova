# config/application.rb

require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Appleseed
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Autoload namespaced model classes.
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '**', '*')].reject { |file| file =~ /.rb\z/ }

    # Autoload decorators.
    %w(decorators forms serializers).each do |decorators|
      config.autoload_paths += Dir[Rails.root.join('app', decorators, '**', '*')].reject { |file| file =~ /.rb\z/ }
    end # each

    # Set FactoryGirl factories directory.
    config.generators do |config|
      config.factory_girl :dir => 'spec/support/factories'
    end # config
  end # class
end # module
