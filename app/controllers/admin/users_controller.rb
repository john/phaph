class Admin::UsersController < Admin::BaseController
  
  public
  
  # GET /users
  def index
    @users = User.all
  end
  
end