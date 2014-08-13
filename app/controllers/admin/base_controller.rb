class Admin::BaseController < ApplicationController
  # layout 'admin'
  layout 'application'

  before_filter :require_admin
  
  private
  
  def require_admin
    redirect_to( root_path, alert: 'Not for you.' ) unless current_user.present? && current_user.name.downcase == 'john mcgrath'
  end
  
  public
  
  def index
    render :template => '/admin/index'
  end
  
end