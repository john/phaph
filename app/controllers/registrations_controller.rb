class RegistrationsController < Devise::RegistrationsController
  
  def new
    
    logger.info "About to call super in RegistrationsController"
    super
    
    # # Kick of sidekiq process to index dropbox
#     logger.info "--------------> next up: GetDropboxFiles.perform_async in RegistrationsController"
#     GetDropboxFiles.perform_async( current_user.id )
#     logger.info "----------> async should have happened."
  end
  
end