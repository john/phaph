class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def twitter
    auth = env["omniauth.auth"]
    @user = User.find_for_oauth(auth, current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def dropbox_oauth2
    
    auth = env["omniauth.auth"]
    @user = User.find_for_oauth(auth, current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Dropbox') if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  alias_method :dropbox, :dropbox_oauth2

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end
  
end