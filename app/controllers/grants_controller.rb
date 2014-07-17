class GrantsController < ApplicationController
  
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :destroy]
  # before_action :check_scope
  before_action :set_grant, only: [:show, :edit, :update, :destroy]

  # GET /grants
  def index
    # @grants = Grant.all
    @model = Grant
    @resources = Grant.all
    render :template => '/shared/resource/index'
  end

  # GET /grants/1
  def show
    @costs = @grant.costs_array
    logger.debug "----------> @costs: #{@costs.inspect}"
    @costs_array = @costs.map do |p|
      p.first
    end
  end

  # GET /grants/new
  def new
    vals = { creator_id: current_user.id }
    if params[:l].present?
      vals[:lab_id] = params[:l].to_i
    end
    @grant = Grant.new( vals )
  end

  # GET /grants/1/edit
  def edit
  end

  # POST /grants
  def create
    @grant = Grant.new(grant_params)

    if @grant.save
      if params[:redirect_to].present?
        redirect_to params[:redirect_to]
      else
        redirect_to @grant, notice: 'Grant successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /grants/1
  def update
    if @grant.update(grant_params)
      redirect_to @grant, notice: 'Grant successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.destroy
    redirect_to grants_url, notice: 'Grant was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grant
      @grant = Grant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def grant_params
      params.require(:grant).permit(:name, :description, :source, :source_id, :principal_investigators, :investigators, :program_manager, :sponsor, :nsf_programs, :nsf_program_reference_code, :nsf_program_element_code, :awarded_at, :starts_at, :ends_at, :amount, :overhead, :creator_id, :user_id, :lab_id, :scope, :state)
    end
end
