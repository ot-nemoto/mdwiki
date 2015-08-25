require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mdwiki
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Tokyo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :ja

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.pages_path = File.expand_path('tmp/pages', ENV['RAILS_ROOT'])
    config.home_page = File.join(config.pages_path, 'HOME')
    config.summary_file = File.join(config.pages_path, 'summary.yml')

    config.after_initialize do
      logger = Logger.new(STDOUT)
      # Make pages directory
      if !FileTest.exist?(config.pages_path)
        FileUtils.mkdir_p(config.pages_path)
        logger.info "Created a page output destination directory. #{config.pages_path}"
      end
      # Initialize home page
      if !FileTest.exist?(config.home_page)
        File.open(config.home_page, "w") do |f|
          f.write '# Welcome to Mdwiki'
        end
        logger.info "Created the initial home page. #{config.home_page}"
      end
      # Initialize summarize.yml
      if !FileTest.exist?(config.summary_file)
        summarize = Hash.new
        summarize.store('HOME', {
          :title => 'Welcome to Mdwiki', :parent_id => nil, :version => Time.now.to_i
        })
        open(config.summary_file, "w") do |f|
          YAML.dump(summarize, f)
        end
        logger.info "Created the initial summary file. #{config.summary_file}"
      end
    end
  end
end
