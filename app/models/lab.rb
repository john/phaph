class Lab < ActiveRecord::Base
  
  has_many :memberships
  # has_many :people, through: :memberships, source: :user
  has_many :grants
  
  validates :name, presence: true
  
  def people
    Membership.where( :belongable_id => id, :belongable_type => Lab.to_s ).map{|membership| membership.user}
  end
  
end
