class Collection < ActiveRecord::Base
  include PublicActivity::Common

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  # tracked owner: ->(controller, model) { controller.current_user }
  
  acts_as_commentable
  acts_as_follower
  acts_as_followable
  
  has_many :collectibles
  has_many :documents, through: :collectibles
  belongs_to :user
  
  validates_presence_of :user, :name, :state
  
  enum state: { active: 0, inactive: 1 }

  def public?
    !!(contribute_scope == Scope::PUBLIC)
  end

  def owned_by?(user)
    if user.present?
      !!(user_id == user.id)
    else
      false
    end
  end

  def follower_count
    # SELECT `follows`.`follower_id` FROM `follows` WHERE `follows`.`follower_type` = 'User' AND `follows`.`followable_type` = 'Collection' AND `follows`.`followable_id` = 2
    Follow.where( follower_type: 'User', followable_type: 'Collection', followable_id: id).count
  end
  
end
