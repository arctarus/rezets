if Rails.env == 'production'
  APP_CONFIG = YAML.load_file(Rails.root.join("config/config.yml"))[Rails.env]
else
  APP_CONFIG = {
    'app_domain' => 'rezets.com',
    'allow_outgoing_email' => true,
    'outgoing' => {
      'tls'  => false,
      'host' => 'smtp.sendgrid.net',
      'port' => '25',
      'auth' => :plain,
      'from' => ENV['SENDGRID_DOMAIN'],
      'user' => ENV['SENDGRID_USERNAME'],
      'pass' => ENV['SENDGRID_PASSWORD']
    }
  }
end
