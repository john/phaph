class HomeController < ApplicationController
  
  def index
    
    if signed_in?
      client = DropboxClient.new( current_user.authentications.first.token )
      @dropbox = client.metadata('/')
    end
    
  end
  
end
