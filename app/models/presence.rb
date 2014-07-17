class Presence < ActiveRecord::Base
  
  belongs_to :location
  belongs_to :locatable, :polymorphic => true
  
  # accepts_nested_attributes_for :locations
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
