class ActivitiesController < ApplicationController

  def index
  	@activities = PublicActivity::Activity.order('created_at desc').where(owner_id: current_user.followee_ids, owner_type: 'User')
  end

end