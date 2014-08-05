class GetDropboxFiles
  include Sidekiq::Worker
  
  def perform( user_id )
    logger.info "Things are happening. DROP! BOX!"
    
    files = []
    user = User.find( user_id )
    files = user.append_dropbox_files(path: '/', files: files)
    
    files.each do |file_to_request|
      puts "--------> file_to_request: #{ file_to_request }"
      
      file = user.dropbox_client.get_file_and_metadata( file_to_request )
      
      # get file metadata, create document
      fmd = file[1]
      doc = Document.new( name: File.basename(fmd['path']), user_id: user.id, service: 'Dropbox', service_id: fmd['rev'], service_revision: fmd['revision'], service_root: fmd['root'], service_path: fmd['path'], service_modified_at: fmd['modified'], service_size_in_bytes: fmd['bytes'], service_mime_type: fmd['mime_type'] )
      
      # add the file data to the doc..
      doc.file_data = file[0]
      
      # save it to trigger indexing
      doc.save
      
    end
    
  end
  
end