require 'carrierwave/orm/activerecord'

CarrierWave.configure do | config |
  case Rails.env
  when 'production' , 'staging'
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.secrets.aws_access_key_id,
      :aws_secret_access_key  => Rails.application.secrets.aws_secret_access_key,
    }

    config.fog_directory = "asquared-#{Rails.env}"
    config.storage       = :fog
  else
    config.storage = :file
  end
end
