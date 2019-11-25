# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'fog/aws'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Check
  # Application configuration
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.assets.precompile << ['html/application-html.css', 'amp/application-amp.css']
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.exceptions_app = routes
    config.app_name = 'Tokens'
    config.app_domain = 'tokensapp.co'
    config.twitter_handle = '@TokensTeam'
  end
end
