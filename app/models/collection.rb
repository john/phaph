class Collection < ActiveRecord::Base
  
  has_many :collectibles
  has_many :documents, through: :collectibles
  belongs_to :user
  
  acts_as_commentable
  
  validates_presence_of :user, :name, :state
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
