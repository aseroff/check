CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.storage = (Rails.env.development? or Rails.env.test?) ? :file : :fog
  config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV["aws_access_id"],
      aws_secret_access_key: ENV["aws_access_secret_key"],
      region: 'us-west-1'
  }
  config.fog_directory  = "checkdata"
  config.fog_public     = false
end