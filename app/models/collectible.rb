class Collectible < ActiveRecord::Base
  
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller.current_user }
  
  # acts_as_commentable
  
  belongs_to :user
  belongs_to :document
  belongs_to :collection
  
end
