class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!

  def index
    if current_user.present?
      @activities = PublicActivity::Activity.order('created_at desc').where(owner_id: current_user.followee_ids, owner_type: 'User')
      
      if current_user.documents.blank?
        flash[:notice] = "It doesn't look like you've added any sites. <a href='/collections/new' class='alert-link'>You should it's fun.</a>"
      end
       
    else
      @signed_out = true
    end
    # @collections = Collection.order(updated_at: :desc).limit(2)
    @documents = Document.order(updated_at: :desc).limit(12)
  end

  def new
  	@collections = Collection.order(updated_at: :desc).limit(10)
    @documents = Document.order(updated_at: :desc).limit(10)
  end

  def popular
  end
  
end
