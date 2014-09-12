class UsersController < ApplicationController
  
  before_filter :authenticate_user!, only: [:edit, :update, :destroy, :follow, :unfollow]
  before_action :set_user, only: [:documents, :collections, :show, :edit, :update, :destroy, :follow, :unfollow]
  
  def follow
    current_user.follow!(@user)
  end

  def unfollow
    current_user.unfollow!(@user)
  end

  
  # Should require a username, in case we ever need to part ways with Dropbox (or anyone else)
  def finish_signup

    # post back. you've filled in the form and submitted it
    if request.patch? && params[:user] #&& params[:user][:email]
      @user = User.find( params[:id] )
      
      if @user.update(user_params) #if current_user.save
        # sign_in(@user, :bypass => true)
        # redirect_to @user, notice: 'Your profile was successfully updated.'
        # sign_in_and_redirect @user, event: :authentication
        redirect_to root_path, notice: "You've been sent a confirmation email, please click the link therein."

      else
        @show_errors = true
      end

    # An unconfimred user has just come from omniauth_callbacks, with a base64-encoded auth token
    else
      token = Base64.decode64( params[:id] )
      if auth = Authentication.find_by_token( token )
        @user = auth.user
      end
    end
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
    # params.permit(accessible)
    params.require(:user).permit(accessible)
  end
  
  
  
  public

  def collections
    # redirect_to root_path alert: 'Not for you.' and return unless @user == current_user
    @collections = Collection.where( user: @user ).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12 )
  end

  def documents
    # redirect_to root_path alert: 'Not for you.' and return unless @user== current_user
    @documents = Document.where(user:  @user).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12 )
  end
  
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
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
      
      logger.debug "@user: #{@user.inspect}"
      
      if params[:location].present?
        location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: location, locatable_id: @user.id, locatable_type: @user.class.to_s )
      end
      
      if user_params[:username].present?
        redirect_to root_path, notice: 'User was successfully updated.'
      else
        redirect_to @user, notice: 'User was successfully updated.'
      end
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

end
