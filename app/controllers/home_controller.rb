class HomeController < ApplicationController
  
  def index
    if current_user.present?
      @collections = Collection.order(created_at: :desc).limit(10)
      @documents = Document.order(created_at: :desc).limit(10)
    end
  end
  
end
