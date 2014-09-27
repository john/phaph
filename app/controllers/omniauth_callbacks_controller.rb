class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def passthru
    render status: 404, text: "Not found. Authentication passthru."
  end
  
  def twitter
    auth = env["omniauth.auth"]

    @user = User.find_for_oauth(auth, current_user)
    
    if @user.persisted?
      if @user.username.present?
        logger.debug "------------------------> flash: #{flash.inspect}"
        logger.debug "------------------------> flash.empty?: #{flash.empty?}"
        logger.debug "------------------------> sign in and redirect!"
        # flash[:notice] = "Welcome back!"
        sign_in_and_redirect @user, event: :authentication

      else
        redirect_to finish_signup_path( Base64.encode64(auth.credentials.token) )
      end
      # set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  # def dropbox_oauth2
    
  #   auth = env["omniauth.auth"]
  #   @user = User.find_for_oauth(auth, current_user)

  #   if @user.persisted?
  #     sign_in_and_redirect @user, event: :authentication
  #     set_flash_message(:notice, :success, kind: 'Dropbox') if is_navigational_format?
  #   else
  #     session["devise.#{provider}_data"] = env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end
  # alias_method :dropbox, :dropbox_oauth2

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  # # This is necessary since Rails 3.0.4
  # # See https://github.com/intridea/omniauth/issues/185
  # # and http://www.arailsdemo.com/posts/44
  # # http://stackoverflow.com/questions/10433681/why-isnt-devise-omniauth-callback-hitting-the-correct-controller
  # protected
  # def handle_unverified_request
  #   true
  # end
  
end