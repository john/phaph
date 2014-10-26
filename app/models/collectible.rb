class Collectible < ActiveRecord::Base
  
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller.current_user }
  
  acts_as_commentable
  acts_as_follower
  acts_as_followable
  
  belongs_to :user
  belongs_to :document
  belongs_to :collection
  
  def get_parent
    if collected_from_id.present?
      Collectible.find(collected_from_id)
    else
      nil
    end
  end
  
end
