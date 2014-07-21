class Category < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :lab
  belongs_to :grant
  
  validates :name, presence: true
  validates :user_id, presence: true
  validates :lab_id, presence: true
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
