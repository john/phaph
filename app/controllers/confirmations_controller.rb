class ConfirmationsController < Devise::ConfirmationsController

  def show
    logger.debug "------------------------> 2flash: #{flash.inspect}"
    logger.debug "------------------------> 2flash.empty?: #{flash.empty?}"
    logger.debug "------------------------> 2sign in and redirect!"
    super
  end

end