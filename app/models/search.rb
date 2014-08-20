class Search < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :user
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
