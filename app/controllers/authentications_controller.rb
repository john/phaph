class AuthenticationsController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_authentication, only: [:show, :edit, :update, :destroy]

  # GET /authentications
  def index
    @authentications = Authentication.all
  end

  # GET /authentications/1
  def show
  end

  # GET /authentications/new
  def new
    @authentication = Authentication.new
  end

  # GET /authentications/1/edit
  def edit
  end

  # POST /authentications
  def create
    @authentication = Authentication.new(authentication_params)

    if @authentication.save
      redirect_to @authentication, notice: 'Authentication was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /authentications/1
  def update
    if @authentication.update(authentication_params)
      redirect_to @authentication, notice: 'Authentication was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /authentications/1
  def destroy
    @authentication.destroy
    redirect_to authentications_url, notice: 'Authentication was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authentication
      @authentication = Authentication.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def authentication_params
      params.require(:authentication).permit(:user_id, :provider, :uid, :access_token, :access_token_secret, :access_token_expires_at, :state)
    end
end
