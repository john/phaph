class GetDropboxTree
  include Sidekiq::Worker
  
  def extract_files(client, path, files)
    directory_contents = client.metadata(path)
    
    directory_contents.each do |file_info|
      if file_info['is_dir'] == true
        extract_files(client, file_info['path'], files)
      else
        files << file_info['path']
      end
    end
  end
  
  
  def perform(name, count)
    # Get dropbox directory structure and files as a single data structure
    # - Get contents of root
    # - Create hash were each key is a file/dir name, values are:
    #   - A string for a file (the filename)
    #   - Another hash for a dir, inside of which you repeat.
    
    
    files = []
    client = DropboxClient.new( current_user.authentications.first.token )
    
    
    extract_files(client, '/', files)
    
    # {"hash"=>"c52f7a2a1ab95d485552872311fdd18b", "thumb_exists"=>false, "bytes"=>0, "path"=>"/", "is_dir"=>true, "icon"=>"folder", "root"=>"dropbox", "contents"=>[{"bytes"=>0, "rev"=>"31602002335", "revision"=>790, "icon"=>"folder_user", "path"=>"/444 Townsend", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Sat, 19 Jul 2014 08:58:08 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"24d02002335", "revision"=>589, "icon"=>"folder", "path"=>"/2012", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Thu, 28 Mar 2013 17:04:00 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"24402002335", "revision"=>580, "icon"=>"folder_camera", "path"=>"/Camera Uploads", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Wed, 17 Oct 2012 19:51:41 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"24e02002335", "revision"=>590, "icon"=>"folder_user", "path"=>"/Entelo", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Thu, 28 Mar 2013 17:04:36 +0000", "size"=>"0 bytes"}, {"rev"=>"902002335", "thumb_exists"=>false, "path"=>"/Getting Started.pdf", "is_dir"=>false, "client_mtime"=>"Wed, 16 Feb 2011 20:13:33 +0000", "icon"=>"page_white_acrobat", "bytes"=>268860, "modified"=>"Wed, 16 Feb 2011 20:13:33 +0000", "size"=>"262.6 KB", "root"=>"dropbox", "mime_type"=>"application/pdf", "revision"=>9}, {"bytes"=>0, "rev"=>"c02002335", "revision"=>12, "icon"=>"folder", "path"=>"/Photos", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Sat, 19 Feb 2011 18:23:26 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"d02002335", "revision"=>13, "icon"=>"folder_public", "path"=>"/Public", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Sat, 19 Feb 2011 18:23:26 +0000", "size"=>"0 bytes"}, {"bytes"=>0, "rev"=>"b02002335", "revision"=>11, "icon"=>"folder_user", "path"=>"/Wordnik", "is_dir"=>true, "thumb_exists"=>false, "root"=>"dropbox", "modified"=>"Wed, 16 Feb 2011 20:19:28 +0000", "size"=>"0 bytes"}], "size"=>"0 bytes"} 
    
   
    
    # Save it to db?
    
    # Queue all files for indexing jobs
    
  end
  
end