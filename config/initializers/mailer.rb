Rezets::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    :host => APP_CONFIG['app_domain']
  }

  # if APP_CONFIG['allow_outgoing_email']
  config.action_mailer.smtp_settings = {
    :enable_starttls_auto  => APP_CONFIG['outgoing']['tls'],
    :address               => APP_CONFIG['outgoing']['host'],
    :port                  => APP_CONFIG['outgoing']['port'],
    :domain                => APP_CONFIG['outgoing']['from'],
    :user_name             => APP_CONFIG['outgoing']['user'],
    :password              => APP_CONFIG['outgoing']['pass'],
    :authentication        => APP_CONFIG['outgoing']['auth']
  }
  # end
end
