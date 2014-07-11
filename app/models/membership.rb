class Membership < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :belongable, :polymorphic => true
  
end
