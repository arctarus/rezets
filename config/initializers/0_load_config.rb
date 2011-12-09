APP_CONFIG = YAML.load_file(Rails.root.join("config/config.yml"))[Rails.env]

APP_CONFIG['outgoing'].merge!({
  'from' => ENV['SENDGRID_DOMAIN'],
  'user' => ENV['SENDGRID_USERNAME'],
  'pass' => ENV['SENDGRID_PASSWORD']
}) if Rails.env == 'production'
