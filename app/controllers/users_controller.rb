class UsersController < ApplicationController
  
  # before_filter :authenticate_user!, except: [:finish_signup]
  before_action :set_user, only: [:documents, :collections, :show, :edit, :update, :destroy, :finish_signup]
  
  
  def set_username
    logger.debug "-----------------> IN set_username"
    @user = current_user
  end
  
  # Should require a username, in case we ever need to part ways with Dropbox (or anyone else)
  def finish_signup
    if request.patch? && params[:user] #&& params[:user][:email]
      logger.debug "-----------------> patch"
      
      logger.debug "-----------------> params[:user]: #{user_params.inspect}"
      logger.debug "-----------------> user_params: #{user_params.inspect}"
      logger.debug "-----------------> email: #{params[:user][:email]}"
      logger.debug "-----------------> username: #{params[:user][:username]}"
      
      # if current_user.update(user_params)
      
      # current_user.confirm!
      # current_user.skip_confirmation!
      # current_user.save
      
      # current_user.email = params[:user][:email]
      # current_user.username = params[:user][:username]
      logger.debug "-----------------> current_user: #{current_user.inspect}"
      logger.debug "--------"
      logger.debug "-----------------> @user: #{@user.inspect}"

      current_user.skip_reconfirmation!
      
      if @user.update(user_params) #if current_user.save
        logger.debug "-----------------> updated user: #{@user.inspect}"
        
        
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
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
    redirect_to root_path alert: 'Not for you.' and return unless @user == current_user
    @collections = Collection.where( user: @user ).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12 )
  end

  def documents
    redirect_to root_path alert: 'Not for you.' and return unless @user== current_user
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
