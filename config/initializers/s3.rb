if Rails.env != 'production'
  S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/s3.yml"))[Rails.env]
  p S3_CREDENTIALS
  ENV['S3_BUCKET']  = S3_CREDENTIALS['bucket']
  ENV['S3_KEY']     = S3_CREDENTIALS['access_key_id']
  ENV['S3_SECRET']  = S3_CREDENTIALS['secret_access_key']
end
