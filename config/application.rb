require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Use spec/mailers/previews as mailer preview
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do | g|
      g.template_engine :slim
      g.assets false
      g.skip_routes true
      g.test_framework :rspec,
        controller_specs: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end

    # Embed authenticate token into remote form
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
