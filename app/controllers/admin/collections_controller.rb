class Admin::CollectionsController < Admin::BaseController
  
  public
  
  # GET /users
  def index
    # @collections = Collection.all
    @model = Collection
    @resources = Collection.paginate(:page => params[:page])
  end
  
end