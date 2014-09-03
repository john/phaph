# require "dropbox_sdk"

class Authentication < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :uid, :provider, :state
  validates_uniqueness_of :uid, :scope => :provider
  
  enum state: { active: 0, inactive: 1 }
  
  def self.find_for_oauth(auth)
    authentication = find_by(provider: auth.provider, uid: auth.uid)
    authentication = create(uid: auth.uid, provider: auth.provider, token: auth.credentials.token ) if authentication.nil?
    
    authentication
  end
  
  
  # from: http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  
  # uid is your user id from dropbox, should be stored in Authentications
  
  # env['omniauth.auth']:
  
  #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash
  
  # secret="rymvd6qwmio6byi" token="b5i5agfeeqp21mtz"> extra=#<OmniAuth::AuthHash access_token=#<OAuth::AccessToken:0x007f850a66ffa8 @token="b5i5agfeeqp21mtz", @secret="rymvd6qwmio6byi", @consumer=#<OAuth::Consumer:0x007f850f886350 @key="jtgzmeyw4zj2pxb", @secret="mc0yzmdeudwmr2m", @options={:signature_method=>"HMAC-SHA1", :request_token_path=>"/oauth/request_token", :authorize_path=>"/oauth/authorize", :access_token_path=>"/oauth/access_token", :proxy=>nil, :scheme=>:header, :http_method=>:post, :oauth_version=>"1.0", :site=>"https://api.dropbox.com", :authorize_url=>"https://www.dropbox.com/1/oauth/authorize", :request_token_url=>"https://api.dropbox.com/1/oauth/request_token", :access_token_url=>"https://api.dropbox.com/1/oauth/access_token"}, @http=#<Net::HTTP api.dropbox.com:443 open=false>, @http_method=:post, @uri=#<URI::HTTPS:0x007f850a66f940 URL:https://api.dropbox.com>>, @params={:oauth_token_secret=>"rymvd6qwmio6byi", "oauth_token_secret"=>"rymvd6qwmio6byi", :oauth_token=>"b5i5agfeeqp21mtz", "oauth_token"=>"b5i5agfeeqp21mtz", :uid=>"21335485", "uid"=>"21335485"}, @response=#<Net::HTTPOK 200 OK readbody=true>> raw_info=#<OmniAuth::AuthHash country="US" display_name="John McGrath" email="john@entelo.com" quota_info=#<OmniAuth::AuthHash datastores=0 normal=242954656 quota=4026531840 shared=66940328> referral_link="https://db.tt/TRCiJl7f" team=nil uid=21335485>> info=#<OmniAuth::AuthHash::InfoHash email="john@entelo.com" name="John McGrath" uid=21335485> provider="dropbox" uid=21335485>
  #
end
