class Presence < ActiveRecord::Base
  
  belongs_to :location
  belongs_to :locatable, :polymorphic => true
  
  # accepts_nested_attributes_for :locations
  
  enum state: { active: 0, inactive: 1 }
  
end
