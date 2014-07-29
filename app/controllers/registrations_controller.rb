class RegistrationsController < Devise::RegistrationsController
  
  def new
    super
    
    # dbsession = DropboxSession.new('jtgzmeyw4zj2pxb', 'mc0yzmdeudwmr2m')
    #
    # logger.debug "ABOUT to serialize dbsession:"
    # logger.debug dbsession.inspect
    #
    # session[:dropbox_session] = dbsession.serialize
  end
  
end