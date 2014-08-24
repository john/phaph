# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  

  # NONE of this should be done an upload time, so it can be done asynchronously.
  # Use Minimagick, put in a method, and it'll be suitable for doing as a job later.
  
  # from: https://github.com/carrierwaveuploader/carrierwave/wiki/Efficiently-converting-image-formats
  # version :thumb_sm do
  #   # def full_filename(for_file)

  #   #   logger = Logger.new("/Users/john/projects/apps/phaph/log/file_uploader.log")
  #   #   logger.debug "------------------> small thumb: #{basename}_sm.png"

  #   #   # model.thumb_sm = "#{model.archive_path}_sm.png"
  #   #   model.thumb_sm = "#{basename}_sm.png"
  #   # end

  #   # def filename
  #   #   "thumb_sm.png"
  #   # end
  #   process :efficient_conversion => [75,75]
  # end

  # version :thumb_md do
  #   # def full_filename(for_file)
  #   #   # model.thumb_md = "#{model.archive_path}_md.png"
  #   #   model.thumb_sm = "#{basename}_md.png"
  #   # end
  #   def filename
  #     "thumb_md.png"
  #   end
  #   process :efficient_conversion => [75,75]
  # end

  # version :thumb_lg do
  #   # def full_filename(for_file)
  #   #   # model.thumb_lg = "#{model.archive_path}_lg.png"
  #   #   model.thumb_sm = "#{basename}_lg.png"
  #   # end
  #   def filename
  #     "thumb_lg.png"
  #   end
  #   process :efficient_conversion => [75,75]
  # end

  # private

  # def efficient_conversion(width, height)
  #   manipulate! do |img|
  #     img.format("png") do |c|
  #       # c.fuzz        "3%"
  #       # c.trim
  #       c.resize      "#{width}x#{height}>"
  #       c.resize      "#{width}x#{height}<"
  #     end

  #     # logger = Logger.new("/Users/john/projects/apps/phaph/log/file_uploader.log")
  #     # logger.debug "------------------> img is: #{img.class}"

  #     img
  #   end
  # end
  
  public
  
  # MAKE THIS AN OPTION. Phaph storage should probably be to S3 too.
  
  # after :store, :export_to_dropbox
  #
  # # Make this a user setting setting; dropbox doesn't need to be required.
  # # Need to store docs outside of /public, with some kind of link method, so
  # # that access control can be applied.
  # def export_to_dropbox(file)
  #   client = DropboxClient.new( model.user.authentications.first.token )
  #
  #   file = open( "#{Rails.root}/public#{model.file_url}" )
  #   response = client.put_file("/Public/#{filename}", file)
  #
  #   model.service = 'Dropbox'
  #   model.service_id = response['rev']
  #   model.service_revision = response['revision']
  #   model.service_root = response['root']
  #   model.service_path = response['path']
  #   model.service_modified_at = response['modified']
  #   model.service_size_in_bytes = response['bytes'].to_i
  #   model.service_mime_type = response['mime_type']
  #   model.save
  # end

  # storage :file
  # # storage :fog
  
  # to use dropbox you need to create a dropbox app:
  # https://www.dropbox.com/developers/apps
  
  # some info on dynamcially setting storage:
  # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Dynamically-set-storage-type
  
  # apparently using dropbox requires a rake task to be run. maybe this can be done programatically
  # when the credentialls are added to the app?
  # load "carrierwave/dropbox/authorize.rake"
  # rake dropbox:authorize APP_KEY=app_key APP_SECRET=app_secret ACCESS_TYPE=dropbox|app_folder
  
  # though that just provides credentials... so maybe if you already have those, it's not necessary?
  
  def self.set_storage
    # if Configuration.use_cloudfiles?
    #   :fog
    # else
      :file
    # end
    
    # :file
    # :dropbox
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
  
  def dropbox_access_token
    model.user.authentications.first.token
  end

  def dropbox_user_id
    model.user.authentications.first.uid
  end
  
  # def extension_white_list
  #   %w(pdf txt doc docx)
  # end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
    model.archive_path
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
