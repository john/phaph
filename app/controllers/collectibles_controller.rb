class CollectiblesController < ApplicationController

  before_action :authenticate_user!, only: [:clone, :new, :edit, :update, :create, :destroy, :follow, :unfollow]
  before_action :set_collectible, only: [:show, :edit, :update, :destroy, :follow, :unfollow, :like, :unlike, :clone]
  
  def show
  	# Add collected_from_id and origin_id  to collectibles table
    @document = @collectible.document
    @title = @collectible.name
    @collection = @document.collection
    @parent = @collectible.get_parent

  	# Get doc (and parent and originator) ids via collectible (pluck w/straight sql)
  end
  
  def edit
    @title = "Edit #{@collectible.name}"
  end
  
  # PATCH/PUT /documents/1
  def update
    if @collectible.update(collectible_params)
      
      # The .update call above should be handling this. Or the .update_document call below should be.
      # Neither is working though, but .index_document does, and it updates in place rather than
      # creating a new es record. Whatever.
      # @document.__elasticsearch__.update_document
      # @document.__elasticsearch__.index_document
      
      redirect_to @collectible, notice: "#{atomic_unit} successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @collectible.destroy
    redirect_to root_path, notice: 'Collectible was successfully deleted.'
  end
  
  def follow
    if request.xhr?
      current_user.follow!(@collectible)
      @collectible.create_activity :follow, owner: current_user
      
      # TODO: send email
    end
  end

  def unfollow
    if request.xhr?
      current_user.unfollow!(@collectible)
      @activity = PublicActivity::Activity.where(trackable_id: @collectible, trackable_type: @collectible.class.to_s, key: 'collectible.follow')
      @activity.destroy_all
      render template: 'collectibles/follow'
    end
  end
  
  def like
    
    # TODO: only xhr?
    
    current_user.like!(@collectible)
    @collectible.create_activity :like, owner: current_user
    
    # TODO: send email
  end

  def unlike
    current_user.unlike!(@collectible)
    @activity = PublicActivity::Activity.where(trackable_id: @collectible, trackable_type: @collectible.class.to_s, key: 'collectible.like')
    @activity.destroy_all
    render template: 'collectibles/like'
  end
  
  def clone
    # TODO: only xhr?
    source = Collectible.find(params[:id])
    @copied_collectible = Collectible.new(collectible_params)
    @copied_collectible.user = current_user
    @copied_collectible.document = @collectible.document
    @copied_collectible.name = @collectible.name
    @copied_collectible.collected_from_id = @collectible.id
    
    if params[:collection_name].present?
      collection = Collection.create!(name: params[:collection_name], user: current_user)
      @copied_collectible.collection = collection
    end
    
    @copied_collectible.save
    @collectible.create_activity :copy, owner: current_user
    
    if @collectible.user.settings(:notify).on_copy == 'yes'
      UserMailer.copy_email(@copied_collectible, @copied_collectible.user, @collectible.user).deliver_later
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collectible
      @collectible = Collectible.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def collectible_params
      params.require(:collectible).permit(:name, :description, :user_id, :document_id, :collection_id )
    end

end