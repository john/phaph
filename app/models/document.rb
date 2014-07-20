class Document < ActiveRecord::Base
  
  belongs_to :creator, class_name: "User"
  belongs_to :lab
  
  validates :name, presence: true
  validates :lab_id, presence: true
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
