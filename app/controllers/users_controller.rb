class UsersController < ApplicationController
  
  before_filter :authenticate_user!, except: [:finish_signup]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  
  
  
  #
  # # @Params : None
  # # @Return : None
  # # @Purpose : To create new dropbox session for authorization
  # def authorize
  #   dbsession = DropboxSession.new('jtgzmeyw4zj2pxb', 'mc0yzmdeudwmr2m')
  #   #serialize and save this DropboxSession
  #   session[:dropbox_session] = dbsession.serialize
  #
  #   logger.debug "------> WE JUST SERIALIZED: #{session[:dropbox_session]}"
  #
  #   #pass to get_authorize_url a callback url that will return the user here
  #   redirect_to dbsession.get_authorize_url url_for(:action => 'dropbox_callback')
  # end
  #
  #
  # # @Params : None
  # # @Return : None
  # # @Purpose : To callback for dropbox authorization
  # def dropbox_callback
  #   dbsession = DropboxSession.deserialize(session[:dropbox_session])
  #   dbsession.get_access_token #we've been authorized, so now request an access_token
  #
  #   # logger.debug "--> access_token: #{access_token.inspect}"
  #   session[:dropbox_session] = dbsession.serialize
  #
  #   logger.debug "------> WE JUST RE-SERIALIZED (should have more info!): #{session[:dropbox_session]}"
  #
  #
  #   client = DropboxClient.new(dbsession, 'dropbox')
  #   logger.debug "----------- ACCOUNT INFO: #{client.account_info.inspect}"
  #   logger.debug "----------- root info: #{client.metadata('/').inspect}"
  #
  #   # current_user.update_attributes(:dropbox_session => session[:dropbox_session])
  #   # session.delete :dropbox_session
  #
  #
  #   flash[:success] = "You have successfully authorized with dropbox."
  #   redirect_to root_path
  # end # end of dropbox_callback action
  #
  
  
  
  
  
  
  # Should require a username, in case we ever need to part ways with Dropbox (or anyone else)
  def finish_signup
    if request.patch? && params[:user] #&& params[:user][:email]
      if current_user.update(user_params)
        current_user.skip_reconfirmation!
        sign_in(current_user, :bypass => true)
        redirect_to current_user, notice: 'Your profile was successfully updated.'
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
    accessible = [ :name, :email, :description, :location, :latitude, :longitude, :state ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
  
  
  
  public
  
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
      
      if params[:location].present?
        location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: location, locatable_id: @user.id, locatable_type: @user.class.to_s )
      end
      
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

end
