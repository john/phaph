class LabsController < ApplicationController
  
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :destroy]
  before_action :set_lab, only: [:show, :edit, :update, :destroy]

  # GET /labs
  def index
    # @labs = Lab.all
    @model = Lab
    @resources = Lab.all
    render :template => '/shared/resource/index'
  end

  # GET /labs/1
  def show
    # @comment = Comment.new
    # @comments = @lab.root_comments
  end

  # GET /labs/new
  def new
    @lab = Lab.new( creator_id: current_user.id )
    # @lab.locations.build
  end

  # GET /labs/1/edit
  def edit
  end

  # POST /labs
  def create
    @lab = Lab.new(lab_params)
    
    if @lab.save
      Membership.create!( user: current_user, belongable_id: @lab.id, belongable_type: @lab.class.to_s, creator_id: current_user.id )
      
      if params[:location].present?
        location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: location, locatable_id: @lab.id, locatable_type: @lab.class.to_s )
      end
      
      redirect_to @lab, notice: 'Lab was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /labs/1
  def update
    
    unupdated_lab = Lab.find(params[:id])
    current_location = (unupdated_lab.locations.present?) ? unupdated_lab.locations.first : nil
    
    if @lab.update(lab_params)
      
      if params[:location].present?
        
        if current_location.present? && current_location.name != params[:location]
          Presence.destroy_all( location: current_location, locatable_id: @lab.id, locatable_type: @lab.class.to_s)
        end
        
        new_location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: new_location, locatable_id: @lab.id, locatable_type: @lab.class.to_s )
        
      end
      
      redirect_to @lab, notice: 'Lab was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /labs/1
  def destroy
    @lab.destroy
    redirect_to labs_url, notice: 'Lab was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lab
      @lab = Lab.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lab_params
      # locations_attributes: [:name, :latitude, :longitude, :city, :state, :country]
      params.require(:lab).permit(:name, :description, :email, :creator_id, :scope, :state )
    end
end
