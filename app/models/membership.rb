class Membership < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :belongable, :polymorphic => true
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
