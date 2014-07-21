class Sample < ActiveRecord::Base
  
  has_many :costs
  has_many :presences, as: :locatable
  has_many :locations, through: :presences
  
  belongs_to :user
  belongs_to :lab
  
  alias_attribute :granted, :amount
  
  validates :name, presence: true
  validates :user_id, presence: true
  validates :lab_id, presence: true
  
  # before_create :assign_unique_token
  #
  # private
  #
  # def assign_unique_token
  #   self.unique_token = ActiveSupport::SecureRandom.hex(10) until unique_token?
  # end
  #
  # def unique_token?
  #   self.class.count(:conditions => {:unique_token => unique_token}) == 0
  # end
  
  
  public
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
end
