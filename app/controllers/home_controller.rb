class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!

  def index
    if current_user.present?
      @activities = PublicActivity::Activity.order('created_at desc').where(owner_id: current_user.followee_ids, owner_type: 'User')
    end
    @collections = Collection.order(updated_at: :desc).limit(2)
    @documents = Document.order(updated_at: :desc).limit(4)
  end

  def new
  	@collections = Collection.order(updated_at: :desc).limit(10)
    @documents = Document.order(updated_at: :desc).limit(10)
  end

  def popular
  end
  
end
