ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto  => APP_CONFIG['outgoing']['tls'],
  :address               => APP_CONFIG['outgoing']['host'],
  :port                  => APP_CONFIG['outgoing']['port'],
  :authentication        => APP_CONFIG['outgoing']['auth'],
  :user_name             => APP_CONFIG['outgoing']['user'],
  :password              => APP_CONFIG['outgoing']['pass'],
  :domain                => APP_CONFIG['outgoing']['from'],
}
