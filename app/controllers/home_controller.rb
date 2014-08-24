class HomeController < ApplicationController
  
  def index
    if current_user.present?
      @collections = Collection.order(updated_at: :desc).limit(10)
      @documents = Document.order(updated_at: :desc).limit(10)
    end
  end
  
end
