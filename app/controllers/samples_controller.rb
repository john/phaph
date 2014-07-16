class SamplesController < ApplicationController
  before_action :set_sample, only: [:show, :edit, :update, :destroy]

  # GET /samples
  def index
    # @samples = Sample.all
    @model = Sample
    @resources = Sample.all
    render :template => '/shared/resource/index'
  end

  # GET /samples/1
  def show
  end

  # GET /samples/new
  def new
    # @sample = Sample.new
    vals = { creator_id: current_user.id }
    if params[:l].present?
      vals[:lab_id] = params[:l].to_i
    end
    @sample = Sample.new( vals )
  end

  # GET /samples/1/edit
  def edit
  end

  # POST /samples
  def create
    @sample = Sample.new(sample_params)

    if @sample.save
      # redirect_to @sample, notice: 'Sample was successfully created.'
      if params[:redirect_to].present?
        redirect_to params[:redirect_to]
      else
        redirect_to @sample, notice: 'Sample successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /samples/1
  def update
    if @sample.update(sample_params)
      redirect_to @sample, notice: 'Sample successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /samples/1
  def destroy
    @sample.destroy
    redirect_to samples_url, notice: 'Sample was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sample_params
      
      params.require(:sample).permit(:name, :description, :source, :creator_id, :lab_id, :grant_id, :location, :latitude, :longitude, :collection_temp, :collected_at, :prepped_at, :analyzed_at, :state)
    end
end
