class IndexDropboxFile
  include Sidekiq::Worker

  def perform(name, count)
    # Get file from Dropbox, save to /tmp
    
    # Index it
    
    # Keep it around for a bit in case you need it, delete everything after, whatever, a week, a day, when the directory gets full
    
  end
  
end