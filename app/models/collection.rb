class Collection < ActiveRecord::Base
  
  acts_as_commentable
  acts_as_follower
  acts_as_followable
  
  has_many :collectibles
  has_many :documents, through: :collectibles
  belongs_to :user
  
  validates_presence_of :user, :name, :state
  
  enum state: { active: 0, inactive: 1 }
  
end
