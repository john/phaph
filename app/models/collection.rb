class Collection < ActiveRecord::Base
  
  has_many :collectibles
  has_many :documents, through: :collectibles
  belongs_to :user
  
  acts_as_commentable
  
  validates_presence_of :user, :name, :state
  
  enum state: { active: 0, inactive: 1 }
  
end
