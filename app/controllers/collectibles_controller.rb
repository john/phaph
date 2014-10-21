class CollectiblesController < ApplicationController
  
  def show

  	# Add collected_from_id and origin_id  to collectibles table
    @collectible = Collectible.find(params[:id])
    @document = @collectible.document
    @title = @document.name
    @collection = @document.collection

  	# Get doc (and parent and originator) ids via collectible (pluck w/straight sql)

    # temp for testing, give it its own view
    render template: 'documents/show'
  end

  def follow
    current_user.follow!(@document)
  end

  def unfollow
    current_user.unfollow!(@document)
    render template: 'documents/follow'
  end

end