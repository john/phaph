class ApplicationController < ActionController::Base
  
  layout 'application'
  
  
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_filter :check_username
  
  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) {
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
        |u| u.permit(registration_params)
      }
      
      devise_parameter_sanitizer.for(:sign_up) {
        |u| u.permit(registration_params)
      }
    end
  end
  
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
  
  def check_username
    # Ensure we don't go into an infinite loop
    return if action_name == 'set_username' || action_name == 'update'
    
    if current_user && current_user.username.blank?
      redirect_to set_username_path
    end
  end
  
  def after_sign_in_path_for(resource)
    if resource.email_verified?
      # super resource
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    else
      finish_signup_path(resource)
    end
  end

  # override the devise sign_out redirect
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
end
