class Admin::UsersController < Admin::BaseController
  
  public
  
  # GET /users
  def index
    @users = User.paginate(:page => params[:page])
  end
  
end