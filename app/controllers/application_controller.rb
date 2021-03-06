class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  protect_from_forgery

  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  # helper_method :current_user
  # hide_action :current_user

  layout 'application'
  
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :ensure_signup_complete, except: [:destroy_user_session] #, only: [:new, :create, :update] # , :destroy
  before_filter :authenticate_user!, :except => [:finish_signup, :user_session]
  
  # needed if we ever support dropbox sign up again, to insure those accounts have usernames
  # before_filter :check_username

  protected

  def app_name
    Rails.configuration.x.app_name
  end
  helper_method :app_name
  
  def app_url
    Rails.configuration.x.app_url
  end
  helper_method :app_url
  
  def app_slogan
    Rails.configuration.x.app_slogan
  end
  helper_method :app_slogan

  def atomic_unit
    Rails.configuration.x.atomic_unit
  end
  helper_method :atomic_unit
  
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
  
  # def check_username
  #   # Ensure we don't go into an infinite loop
  #   return if action_name == 'set_username' || action_name == 'update' || action_name == 'finish_signup'
  #
  #   if current_user.present? && current_user.username.blank?
  #     redirect_to set_username_path
  #   end
  # end
  
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
