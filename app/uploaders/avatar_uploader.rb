# frozen_string_literal: true

# Uploader for User avatars
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}-#{Rails.env}/#{mounted_as}/#{model.id}"
  end

  def default_url(*_args)
    ActionController::Base.helpers.asset_path('fallback/' + [version_name, 'default-avatar.png'].compact.join('_'))
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [100, 100]
  end

  version :medium do
    process resize_to_fill: [300, 300]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w[jpg jpeg gif png]
  end

  def size_range
    1..1.5.megabytes
  end
end
