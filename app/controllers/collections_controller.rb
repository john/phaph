class CollectionsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update, :destroy, :follow, :unfollow]
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :follow, :unfollow]

  def follow
    current_user.follow!(@collection)
  end

  def unfollow
    current_user.unfollow!(@collection)
    render template: 'collections/follow'
  end
  
  # GET /collections
  def index
    @model = Collection
    @resources = Collection.where(:user => current_user).paginate(:page => params[:page])
  end

  # GET /collections/1
  def show
    @title = @collection.name
  end

  # GET /collections/new
  def new
    @title = "New collection"
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
    @title = "Edit #{@collection.name}"
  end

  # POST /collections
  def create
    @collection = Collection.new(collection_params)
    @collection.user = current_user

    if @collection.save
      @collection.create_activity :create, owner: current_user
      # redirect_to @collection, notice: 'Collection was successfully created.'
      redirect_to new_document_path(collection_id: @collection.id), notice: "Collection successfully created. Now <b class='alert-link'>add a site:</b>".html_safe
    else
      render :new
    end
  end

  # PATCH/PUT /collections/1
  def update
    if @collection.update(collection_params)
      redirect_to @collection, notice: 'Collection was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /collections/1
  def destroy
    @collection.destroy
    redirect_to collections_url, notice: 'Collection was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def collection_params
      params.require(:collection).permit(:name, :description, :view_scope, :contribute_scope, :state)
    end
end
