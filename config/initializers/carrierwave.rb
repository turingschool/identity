require 'carrierwave/orm/activerecord'

CarrierWave.configure do | config |
  case Rails.env
  when 'production' , 'staging'
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV[ 'AWS_ACCESS_KEY_ID' ],
      :aws_secret_access_key  => ENV[ 'AWS_SECRET_ACCESS_KEY' ]
    }

    config.fog_directory = "asquared-#{ Rails.env }"
    config.storage       = :fog
  else
    config.storage = :file
  end
end
