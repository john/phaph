class RegistrationsController < Devise::RegistrationsController
  
  # def new
  #
  #   logger.info "About to call super in RegistrationsController"
  #   super
  #
  #   # # Kick of sidekiq process to index dropbox
  #   # logger.info "--------------> next up: GetDropboxFiles.perform_async in RegistrationsController"
  #   # GetDropboxFiles.perform_async( current_user.id )
  #   # logger.info "----------> async should have happened."
  # end
  #
  
  before_filter :configure_permitted_parameters
 
  protected

  # http://stackoverflow.com/questions/16379554/strong-parameters-with-rails-4-0-and-devise
  # custom field is :username
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :username, :email, :password)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end
  
end