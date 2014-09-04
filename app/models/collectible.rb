class Collectible < ActiveRecord::Base
  
  acts_as_commentable
  
  belongs_to :user
  belongs_to :document
  belongs_to :collection
  
end
