class LabsController < ApplicationController
  before_action :set_lab, only: [:show, :edit, :update, :destroy]

  # GET /labs
  def index
    @labs = Lab.all
  end

  # GET /labs/1
  def show
  end

  # GET /labs/new
  def new
    @lab = Lab.new( creator_id: current_user.id )
  end

  # GET /labs/1/edit
  def edit
  end

  # POST /labs
  def create
    @lab = Lab.new(lab_params)

    if @lab.save
      redirect_to @lab, notice: 'Lab was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /labs/1
  def update
    if @lab.update(lab_params)
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
      params.require(:lab).permit(:name, :description, :creator_id, :state)
    end
end
