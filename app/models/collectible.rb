class Collectible < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :document
  belongs_to :collection
  
  acts_as_commentable
  
end
