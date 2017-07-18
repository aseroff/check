Koala.configure do |config|
  config.access_token = ENV["fb_access_token"]
  config.app_access_token = ENV["fb_app_access_token"]
  config.app_id = 148252602418115
  config.app_secret = ENV["fb_secret_key"]
end