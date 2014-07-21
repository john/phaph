class Lab < ActiveRecord::Base
  acts_as_commentable
  
  has_many :memberships
  has_many :grants
  has_many :samples
  has_many :documents
  has_many :presences, as: :locatable
  has_many :locations, through: :presences
  belongs_to :user
  
  # accepts_nested_attributes_for :locations
  # accepts_nested_attributes_for :presences
  
  validates :name, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, unless: Proc.new {|c| c.email.blank?}
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
  # replace with association: has_many :people, through: :memberships, classname: User
  def people
    Membership.where( :belongable_id => id, :belongable_type => Lab.to_s ).map{|membership| membership.user}
  end
  
end
