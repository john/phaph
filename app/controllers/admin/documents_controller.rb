class Admin::DocumentsController < Admin::BaseController
  
  public
  
  # GET /users
  def index
    @model = Document
    @resources = Document.paginate(:page => params[:page])
  end
  
end