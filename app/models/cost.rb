class Cost < ActiveRecord::Base
  
  belongs_to :creator, class_name: "User"
  belongs_to :organization
  belongs_to :grant
  
  validates_presence_of :name, :creator, :organization, :state
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
