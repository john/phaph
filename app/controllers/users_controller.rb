class UsersController < ApplicationController
  
  before_filter :authenticate_user!, only: [:index, :edit, :update, :destroy, :followers, :follow, :unfollow]
  before_action :set_user, only: [:documents, :collections, :show, :edit, :update, :destroy, :followers, :follow, :unfollow]
  
  def follow
    if request.xhr?
      @replace = params[:replace].present? ? params[:replace] : '.btn-follow'
      current_user.follow!(@user)
      
      @user.create_activity :follow, owner: current_user
      
      if @user.settings(:notify).on_follow == 'yes'
        UserMailer.follow_user_email(current_user, @user).deliver_later
      end
    end
  end

  def unfollow
    if request.xhr?
      @replace = params[:replace].present? ? params[:replace] : '.btn-follow'
      current_user.unfollow!(@user)
      @activity = PublicActivity::Activity.where(trackable_id: @user, trackable_type: @user.class.to_s, key: 'user.follow')
      @activity.destroy_all 
    end
  end

  # Should require a username, in case we ever need to part ways with Dropbox (or anyone else)
  def finish_signup
    logger.debug "------------------------> flash: #{flash.inspect}"
    logger.debug "------------------------> flash.empty?: #{flash.empty?}"
    logger.debug "------------------------> sign in and redirect!"

    # post back. you've filled in the form and submitted it
    if request.patch? && params[:user] #&& params[:user][:email]
      @user = User.find( params[:id] )
      
      if @user.update(user_params) #if current_user.save
        logger.debug "-----------------------> UPDATED user"
        # sign_in(@user, :bypass => true)
        # redirect_to @user, notice: 'Your profile was successfully updated.'
        # sign_in_and_redirect @user, event: :authentication
        redirect_to root_path, notice: "You've been sent a confirmation email, please <b class='alert-link'>click the link therein</b>."

      else
        logger.debug "-----------------------> FAILED to update user"
        @show_errors = true
      end

    # An unconfimred user has just come from omniauth_callbacks, with a base64-encoded auth token
    else
      logger.debug "-----------------------> UNCOnfirmed (#{params[:id]})"
      token = Base64.decode64( params[:id] )
      logger.debug "--------------> token: #{token.inspect}"

      if auth = Authentication.find_by_token( token )
        logger.debug "--------------> getting user"
        @user = auth.user
      else
        logger.debug "--------------> NO find_by_token"
      end
    end
  end

  def collections
    @title = "#{(@user == current_user) ? 'Your' : "#{@user.name}'s"} collections"
    @collections = Collection.where( user: @user ).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12 )
  end

  def documents
    @title = "#{(@user == current_user) ? 'Your' : "#{@user.name}'s"} documents"
    @collectibles = Collectible.where(user:  @user).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12 )
  end
  
  # GET /users
  def index
    @title = "#{app_name} users"
    @users = User.all
  end

  # GET /users/1
  def show
    @title = @user.name

    @followed_users = @user.followees(User)
    @followed_collectibles = @user.followees(Collectible)
    @followed_collections = @user.followees(Collection)
  end
  
  def followers
    @title = "#{@user.name} | followers}"

    @followers = @user.followers(User)
    @followed_collectibles = @user.followees(Collectible)
    @followed_collections = @user.followees(Collection)
  end

  # GET /users/new
  def new
    @title = "New person"
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @title = "Edit #{@user.name}"
    @user.on_follow = @user.settings(:notify).on_follow
    @user.on_add = @user.settings(:notify).on_add
    @user.on_comment = @user.settings(:notify).on_comment
    @user.on_copy = @user.settings(:notify).on_copy
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      
      if params[:location].present?
        location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: location, locatable_id: @user.id, locatable_type: @user.class.to_s )
      end
      
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      
      if params[:location].present?
        location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: location, locatable_id: @user.id, locatable_type: @user.class.to_s )
      end
      
      @user.settings(:notify).on_follow = @user.on_follow
      @user.settings(:notify).on_add = @user.on_add
      @user.settings(:notify).on_comment = @user.on_comment
      @user.settings(:notify).on_copy = @user.on_copy
      @user.save!
      
      if user_params[:username].present?
        redirect_to root_path, notice: 'User was successfully updated.'
      else
        redirect_to @user, notice: 'User was successfully updated.'
      end
    else
      render :edit
    end
  end
  
  # def update_settings
  #   #s.key :notify, :defaults => { :on_follow => true, :on_add => true, :on_comment => true, :on_copy => true }
  #   if @user = User.find(params[:id])
  #     u.settings(:notify).on_follow = params[:on_follow]
  #     u.settings(:notify).on_add = params[:on_add]
  #     u.settings(:notify).on_comment = params[:on_comment]
  #     u.settings(:notify).on_copy = params[:on_copy]
  #     u.save!
  #     redirect_to
  #   end
  # end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # # Only allow a trusted parameter "white list" through.
  # def user_params
  #   params[:user]
  # end
  
  def user_params
    accessible = [ :name, :username, :email, :description, :location, :latitude, :longitude, :state ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    accessible << [ :on_follow, :on_add, :on_comment, :on_copy]
    # params.permit(accessible)
    params.require(:user).permit(accessible)
  end

end
