class OrganizationsController < ApplicationController
  
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :destroy]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  def index
    # @organizations = Organization.all
    @model = Organization
    @resources = Organization.all
    render :template => '/shared/resource/index'
  end

  # GET /organizations/1
  def show
    # @comment = Comment.new
    # @comments = @organization.root_comments
  end

  # GET /organizations/new
  def new
    @organization = Organization.new( user_id: current_user.id )
    # @organization.locations.build
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      Membership.create!( user: current_user, belongable_id: @organization.id, belongable_type: @organization.class.to_s, creator_id: current_user.id )
      
      if params[:location].present?
        location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: location, locatable_id: @organization.id, locatable_type: @organization.class.to_s )
      end
      
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /organizations/1
  def update
    
    unupdated_organization = Organization.find(params[:id])
    current_location = (unupdated_organization.locations.present?) ? unupdated_organization.locations.first : nil
    
    if @organization.update(organization_params)
      
      if params[:location].present?
        
        if current_location.present? && current_location.name != params[:location]
          Presence.destroy_all( location: current_location, locatable_id: @organization.id, locatable_type: @organization.class.to_s)
        end
        
        new_location = Location.find_or_create_by!( name: params[:location] )
        Presence.find_or_create_by!( location: new_location, locatable_id: @organization.id, locatable_type: @organization.class.to_s )
        
      end
      
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: 'Organization was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def organization_params
      # locations_attributes: [:name, :latitude, :longitude, :city, :state, :country]
      params.require(:organization).permit(:name, :description, :email, :user_id, :scope, :state )
    end
end
