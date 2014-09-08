class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :lockable, :omniauthable, :omniauth_providers => [:dropbox_oauth2, :twitter]
  
  acts_as_commentable
  acts_as_follower
  acts_as_followable

  has_many :presences, as: :locatable
  has_many :locations, through: :presences
  has_many :authentications
  has_many :documents
  has_many :collectibles
  has_many :collections
  
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update
  
  enum state: { active: 0, inactive: 1, archived: 2 }
  
  # after_create :get_dropbox
  #
  # def get_dropbox
  #   # Kick off sidekiq process to index dropbox
  #   logger.info "--------------> next up: GetDropboxFiles.perform_async in RegistrationsController"
  #   GetDropboxFiles.perform_async( self.id )
  #   logger.info "----------> async should have happened."
  # end

  def followee_ids()
    sql = "SELECT `users`.id
            FROM `users`
            WHERE `users`.`id`
            IN
              (SELECT `follows`.`followable_id`
                FROM `follows`
                WHERE `follows`.`followable_type` = 'User'
                AND `follows`.`follower_type` = 'User'
                AND `follows`.`follower_id` = #{id})"
    res = User.connection.execute( sql )
    (res.present?) ? res.first : []
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
  
  
  # PUT mime type list someplace better
  # This isn't a great method, really
  def append_dropbox_files( path: path, files: [], mime_types: Document::MIME_TYPES )
    directory = dropbox_client.metadata( path, 1000)
    directory['contents'].each do |file|
      if file['is_dir'] == true
        unless file['path'] == '/2012'
          puts "recurse..."
          append_dropbox_files( path: file['path'], files: files )
        end
      else
        if mime_types.include?( file['mime_type'] )
          puts "adding: #{file['path']}"
          files << file['path']
        else
          puts "skipping: #{file['path']}"
        end
      end
    end
    files
  end
  
  def dropbox_client
    @_dropbox_client ||= begin
      token = Authentication.where( user_id: id, provider: 'dropbox_oauth2' ).first.token
      @_dropbox_client = DropboxClient.new( token )
    end
  end

  def organizations
    Membership.where( :user_id => id, :belongable_type => Organization.to_s ).map{|membership| membership.belongable}
  end
  
  def self.find_for_oauth(auth, signed_in_resource = nil)

      # Get the authentication and user if they exist
      authentication = Authentication.find_for_oauth(auth)
      # authentication.state = :active

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
        email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email if email_is_verified
        user = User.where(:email => email).first if email

        # Create the user if it's a new registration
        if user.nil?
          user = User.new(
            name: auth.info.name,
            # state: :active,
            #username: auth.info.nickname || auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
          )
          
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
