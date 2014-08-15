class Collection < ActiveRecord::Base
  
  has_many :documents
  belongs_to :user
  
  acts_as_commentable
  
  validates_presence_of :user, :name, :state
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
