# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  # storage :file
  # # storage :fog
  
  # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Dynamically-set-storage-type
  def self.set_storage
    # if Configuration.use_cloudfiles?
    #   :fog
    # else
    #   :file
    # end
    puts "-------------> IN CLASS Method!"
    :file
  end
  storage set_storage

  # # https://groups.google.com/forum/#!topic/carrierwave/CFGFKYFfyG4
  # # "All the config options are ultimately instance methods, so you should be
  # # able to do something like (below), and so on, for the other variables.
  # def s3_access_key_id
  #   model.user.s3_access_key_id
  # end
  #
  # # https://github.com/sorentwo/carrierwave-aws
  # # https://github.com/robin850/carrierwave-dropbox
  
  
  
  
  def extension_white_list
    %w(pdf txt doc docx)
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end