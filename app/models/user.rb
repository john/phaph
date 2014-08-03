class User < ActiveRecord::Base
  
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  
  has_many :presences, as: :locatable
  has_many :locations, through: :presences
  
  has_many :authentications
  
  has_many :documents
  
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable, :omniauth_providers => [:dropbox_oauth2]
  
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update
  
  
  
  # def people
  #   Membership.where( :belongable_id => id, :belongable_type => Lab.to_s ).map{|membership| membership.user}
  # end


  # Membership.where( :belongable_id => id, :belongable_type => Grant.to_s ).map{|membership| membership.user}
  def labs
    Membership.where( :user_id => id, :belongable_type => Lab.to_s ).map{|membership| membership.belongable}
  end
  
  def grants
    Membership.where( :user_id => id, :belongable_type => Grant.to_s ).map{|membership| membership.belongable}
  end
  
  
  # def self.find_for_oauth(auth, signed_in_resource = nil)
  #
  #   # called from omniauth_callbacks_controller with : @user = User.find_for_oauth(env["omniauth.auth"], current_user)
  #
  #   # as implemented in: # http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  #
  #   # Get the Authentication and user if they exist
  #   authentication = Authentication.find_for_oauth(auth)
  #
  #   # If a signed_in_resource is provided it always overrides the existing user
  #   # to prevent the identity being locked with accidentally created accounts.
  #   # Note that this may leave zombie accounts (with no associated identity) which
  #   # can be cleaned up at a later date.
  #   user = signed_in_resource ? signed_in_resource : authentication.user
  #
  #   # Create the user if needed
  #   if user.nil?
  #
  #     # Get the existing user by email if the provider gives us a verified email.
  #     # If no verified email was provided we assign a temporary email and ask the
  #     # user to verify it on the next step via UsersController.finish_signup
  #     # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
  #
  #     # skip the verified crap
  #
  #     # @user = User.find_for_oauth(auth, current_user)
  #     @user = User.find_for_oauth(auth)
  #
  #
  #     email = auth.info.email #if email_is_verified
  #
  #     user = User.where(:email => email).first if email
  #
  #     # Create the user if it's a new registration
  #     if user.nil?
  #
  #       user = User.new(
  #         name: auth.info.name,
  #         #username: auth.info.nickname || auth.uid,
  #         email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
  #         password: Devise.friendly_token[0,20]
  #       )
  #
  #       # Probably don't really want to skip confirmation
  #       user.skip_confirmation!
  #       user.save!
  #     end
  #   end
  #
  #   # Associate the Authentication with the user if needed
  #   if authentication.user != user
  #     authentication.user = user
  #     authentication.save!
  #   end
  #   user
  # end
  
  
  
  
  def self.find_for_oauth(auth, signed_in_resource = nil)

      # Get the authentication and user if they exist
      authentication = Authentication.find_for_oauth(auth)

      # If a signed_in_resource is provided it always overrides the existing user
      # to prevent the authentication being locked with accidentally created accounts.
      # Note that this may leave zombie accounts (with no associated authentication) which
      # can be cleaned up at a later date.
      user = signed_in_resource ? signed_in_resource : authentication.user

      # Create the user if needed
      if user.nil?

        # Get the existing user by email if the provider gives us a verified email.
        # If no verified email was provided we assign a temporary email and ask the
        # user to verify it on the next step via UsersController.finish_signup
        # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email # if email_is_verified
        user = User.where(:email => email).first if email

        # Create the user if it's a new registration
        if user.nil?
          user = User.new(
            name: auth.info.name,
            #username: auth.info.nickname || auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
          )
          
          # Probably don't really want to skip confirmation
          user.skip_confirmation!
          user.save!
        end
      end

      # Associate the authentication with the user if needed
      if authentication.user != user
        authentication.user = user
        authentication.save!
      end
      user
    end
    
    
  
  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
  
end
