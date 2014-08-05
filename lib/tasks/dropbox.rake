namespace :dropbox do

  # bundle exec rake dropbox:get_files --trace
  desc "Get dropbox structure"
  task :get_files => :environment do
    
    files = []
    user = User.find(1)
    
    files = user.append_dropbox_files(path: '/', files: files)
    
    files.each do |file_to_request|
      
      
      
      puts "--------> file_to_request: #{ file_to_request }"
      
      file = user.dropbox_client.get_file_and_metadata( file_to_request )
      
      # get file metadata
      fmd = file[1]
      
      doc = Document.new( name: File.basename(fmd['path']), user_id: user.id, service: 'Dropbox', service_id: fmd['rev'], service_revision: fmd['revision'], service_root: fmd['root'], service_path: fmd['path'], service_modified_at: fmd['modified'], service_size_in_bytes: fmd['bytes'], service_mime_type: fmd['mime_type'] )
      
      doc.file_data = file[0]
      # save the Document, which should trigger indexing
      doc.save
      
      raise "should have one file in there"
      # delete the downloaded file?
    end
    
  end

end

# file:
# [file_data, {"rev"=>"3d802002335", "thumb_exists"=>false, "path"=>"/Public/climate-change-full.pdf", "is_dir"=>false, "client_mtime"=>"Sat, 02 Aug 2014 02:46:35 +0000", "icon"=>"page_white_acrobat", "bytes"=>3871733, "modified"=>"Sat, 02 Aug 2014 02:46:34 +0000", "size"=>"3.7 MB", "root"=>"dropbox", "mime_type"=>"application/pdf", "revision"=>984}] 

# metadata:
# {"hash"=>"c52f7a2a1ab95d485552872311fdd18b", "thumb_exists"=>false, "bytes"=>0, "path"=>"/", "is_dir"=>true, "icon"=>"folder", "root"=>"dropbox", "contents"=>[{"bytes"=>0, "rev"=>"31602002335", "revision"=>790, "icon"=>"folder_user", "path"=>"/444 Townsend", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Sat, 19 Jul 2014 08:58:08 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"24d02002335", "revision"=>589, "icon"=>"folder", "path"=>"/2012", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Thu, 28 Mar 2013 17:04:00 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"24402002335", "revision"=>580, "icon"=>"folder_camera", "path"=>"/Camera Uploads", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Wed, 17 Oct 2012 19:51:41 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"24e02002335", "revision"=>590, "icon"=>"folder_user", "path"=>"/Entelo", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Thu, 28 Mar 2013 17:04:36 +0000", "size"=>"0 bytes"}, {"rev"=>"902002335", "thumb_exists"=>false, "path"=>"/Getting Started.pdf", "is_dir"=>false, "client_mtime"=>"Wed, 16 Feb 2011 20:13:33 +0000", "icon"=>"page_white_acrobat", "bytes"=>268860, "modified"=>"Wed, 16 Feb 2011 20:13:33 +0000", "size"=>"262.6 KB", "root"=>"dropbox", "mime_type"=>"application/pdf", "revision"=>9}, {"bytes"=>0, "rev"=>"c02002335", "revision"=>12, "icon"=>"folder", "path"=>"/Photos", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Sat, 19 Feb 2011 18:23:26 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"d02002335", "revision"=>13, "icon"=>"folder_public", "path"=>"/Public", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Sat, 19 Feb 2011 18:23:26 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"b02002335", "revision"=>11, "icon"=>"folder_user", "path"=>"/Wordnik", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Wed, 16 Feb 2011 20:19:28 +0000", "size"=>"0 bytes"}], "size"=>"0 bytes"} 