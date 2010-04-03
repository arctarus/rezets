# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/rezets.yml")[RAILS_ENV]

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "will_paginate"
  config.gem "paperclip"
  config.gem "authlogic"
  config.gem 'sitemap_generator', :lib => false, :source => 'http://gemcutter.org'

  # gems to gettext
  config.gem "locale"
  config.gem "locale_rails", :version => '2.0.5'
  config.gem "gettext"
  config.gem "gettext_activerecord", :version => '2.1.0'
  config.gem "gettext_rails", :version => '2.1.0'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    :host => "rezets.com"
  }
  config.action_mailer.smtp_settings = {
    :enable_starttls_auto  => APP_CONFIG['outgoing']['enable_starttls_auto'],
    :address               => APP_CONFIG['outgoing']['host'],
    :port                  => APP_CONFIG['outgoing']['port'],
    :domain                => APP_CONFIG['outgoing']['from'],
    :user_name             => APP_CONFIG['outgoing']['user'],
    :password              => APP_CONFIG['outgoing']['pass'],
    :authentication        => APP_CONFIG['outgoing']['auth'].to_sym
  }

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :comment_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  # config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :es

end

WillPaginate::ViewHelpers.pagination_options[:prev_label]=I18n.t("pagination.prev")
WillPaginate::ViewHelpers.pagination_options[:next_label]=I18n.t("pagination.next")
