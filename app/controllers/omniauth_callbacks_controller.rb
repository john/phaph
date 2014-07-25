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
  
  
  def dropbox
    
    logger.debug "-------------------> in dropbox"
    
    logger.debug "env['omniauth.auth']: #{env['omniauth.auth']}"
    
    # env['omniauth.auth']: #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash secret="rymvd6qwmio6byi" token="b5i5agfeeqp21mtz"> extra=#<OmniAuth::AuthHash access_token=#<OAuth::AccessToken:0x007f850a66ffa8 @token="b5i5agfeeqp21mtz", @secret="rymvd6qwmio6byi", @consumer=#<OAuth::Consumer:0x007f850f886350 @key="jtgzmeyw4zj2pxb", @secret="mc0yzmdeudwmr2m", @options={:signature_method=>"HMAC-SHA1", :request_token_path=>"/oauth/request_token", :authorize_path=>"/oauth/authorize", :access_token_path=>"/oauth/access_token", :proxy=>nil, :scheme=>:header, :http_method=>:post, :oauth_version=>"1.0", :site=>"https://api.dropbox.com", :authorize_url=>"https://www.dropbox.com/1/oauth/authorize", :request_token_url=>"https://api.dropbox.com/1/oauth/request_token", :access_token_url=>"https://api.dropbox.com/1/oauth/access_token"}, @http=#<Net::HTTP api.dropbox.com:443 open=false>, @http_method=:post, @uri=#<URI::HTTPS:0x007f850a66f940 URL:https://api.dropbox.com>>, @params={:oauth_token_secret=>"rymvd6qwmio6byi", "oauth_token_secret"=>"rymvd6qwmio6byi", :oauth_token=>"b5i5agfeeqp21mtz", "oauth_token"=>"b5i5agfeeqp21mtz", :uid=>"21335485", "uid"=>"21335485"}, @response=#<Net::HTTPOK 200 OK readbody=true>> raw_info=#<OmniAuth::AuthHash country="US" display_name="John McGrath" email="john@entelo.com" quota_info=#<OmniAuth::AuthHash datastores=0 normal=242954656 quota=4026531840 shared=66940328> referral_link="https://db.tt/TRCiJl7f" team=nil uid=21335485>> info=#<OmniAuth::AuthHash::InfoHash email="john@entelo.com" name="John McGrath" uid=21335485> provider="dropbox" uid=21335485>
    
    
    # uid is your user id from dropbox, should be stored in Authentications
    
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
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