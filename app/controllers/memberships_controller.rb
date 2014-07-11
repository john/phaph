class MembershipsController < ApplicationController

  # POST /labs
  def create
    @membership = Membership.new(membership_params)

    if @membership.save
      # redirect_to Lab.find(@membership.lab_id), notice: 'Membership was successfully created.'
      redirect_to @membership.belongable, notice: 'Membership was successfully created.'
    else
      redirect_to root_path, notice: 'Something went wrong.'
    end
  end
  
  private
  
    # Only allow a trusted parameter "white list" through.
    def membership_params
      params.require(:membership).permit(:creator_id, :user_id, :belongable_id, :belongable_type, :state)
    end

end
