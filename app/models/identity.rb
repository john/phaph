class Identity < ActiveRecord::Base
  belongs_to :user
  
  ###############################
  # from:
  # http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity
  end
  ###############################
  
end
