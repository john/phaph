class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!

  def index
    if current_user.present?
      @collections = Collection.order(updated_at: :desc).limit(10)
      @documents = Document.order(updated_at: :desc).limit(10)
    end
  end
  
end
