class Grant < ActiveRecord::Base
  
  belongs_to :creator, class_name: "User"
  belongs_to :lab
  
  validates :name, presence: true
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
  def people
    Membership.where( :belongable_id => id, :belongable_type => Grant.to_s ).map{|membership| membership.user}
  end
  
end
