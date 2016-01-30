# Rezets::Application.config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
#   r301 %r{.*}, "http://#{APP_CONFIG['app_domain']}$&", :if => Proc.new {|rack_env|
#     rack_env['SERVER_NAME'] != APP_CONFIG['app_domain']
#   }
# end if Rails.env.production?
