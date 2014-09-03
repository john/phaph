class Membership < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :belongable, :polymorphic => true
  
  enum state: { active: 0, inactive: 1 }
  
end
