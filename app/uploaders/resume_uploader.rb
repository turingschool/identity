# encoding: utf-8

class ResumeUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  process :set_content_type

  def extension_white_list
    %w( pdf )
  end

  def store_dir
    "uploads/asset_#{ model.id }"
  end

  def filename
    "#{model.owner_slug}.pdf" if original_filename
  end
end
