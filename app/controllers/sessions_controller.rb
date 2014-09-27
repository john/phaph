class SessionsController < Devise::SessionsController

  skip_before_filter
  
  def new
    logger.debug "------------------------> 2flash: #{flash.inspect}"
    logger.debug "------------------------> 2flash.empty?: #{flash.empty?}"
    logger.debug "------------------------> 2sign in and redirect!"

    @title = 'Sign in'
    super
  end

end