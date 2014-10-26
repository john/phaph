class SessionsController < Devise::SessionsController

  skip_before_filter
  
  def new
    @title = 'Sign in'
    super
  end

end