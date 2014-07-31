class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # # http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  # def self.provides_callback_for(provider)
  #
  #   # dynamically add method for each supported provider
  #   class_eval %Q{
  #     def #{provider}
  #
  #       logger.debug "-------------------> in def provider"
  #
  #       logger.debug "env['omniauth.auth']: #{env['omniauth.auth']}"
  #
  #       @user = User.find_for_oauth(env["omniauth.auth"], current_user)
  #
  #       if @user.persisted?
  #         sign_in_and_redirect @user, event: :authentication
  #         set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  #       else
  #         session["devise.#{provider}_data"] = env["omniauth.auth"]
  #         redirect_to new_user_registration_url
  #       end
  #     end
  #   }
  # end

  # # [:twitter, :facebook, :linked_in].each do |provider|
  # [:dropbox].each do |provider|
  #   provides_callback_for provider
  # end
  
  
  def dropbox_oauth2
    
    auth = env["omniauth.auth"]
    logger.debug "=================> #{auth.inspect}"
    logger.debug "-----------------> #{auth.credentials.token}"
    logger.debug "-----------------> #{auth.info.name}"
    logger.debug "-----------------> #{auth.info.email}"
    logger.debug "-----------------> #{auth.info.uid}"
    
    @user = User.find_for_oauth(auth, current_user)

    if @user.persisted?
      # client = DropboxClient.new( auth.credentials.token )
      # @dropbox = client.metadata('/')
      
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Dropbox') if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end
  
end