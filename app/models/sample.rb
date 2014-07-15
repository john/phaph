class Sample < ActiveRecord::Base
  
  belongs_to :creator, class_name: "User"
  belongs_to :lab
  has_many :costs
  
  alias_attribute :granted, :amount
  
  validates :name, presence: true
  validates :creator_id, presence: true
  validates :lab_id, presence: true
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
