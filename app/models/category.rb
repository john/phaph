class Category < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :lab
  belongs_to :grant
  
  validates_presence_of :name, :user, :lab, :state
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
