class Lab < ActiveRecord::Base
  
  has_many :memberships
  # has_many :people, through: :memberships, source: :user
  has_many :grants
  has_many :samples
  
  validates :name, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
  def people
    Membership.where( :belongable_id => id, :belongable_type => Lab.to_s ).map{|membership| membership.user}
  end
  
end
