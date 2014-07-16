class PapersController < ApplicationController
  before_action :set_paper, only: [:show, :edit, :update, :destroy]

  # GET /papers
  def index
    @model = Paper
    @resources = Paper.all
    render :template => '/shared/resource/index'
  end

  # GET /papers/1
  def show
  end

  # GET /papers/new
  def new
    @paper = Paper.new
  end

  # GET /papers/1/edit
  def edit
  end

  # POST /papers
  def create
    @paper = Paper.new(paper_params)

    if @paper.save
      # redirect_to @paper, notice: 'Paper was successfully created.'
      if params[:redirect_to].present?
        redirect_to params[:redirect_to]
      else
        redirect_to @paper, notice: 'Paper successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /papers/1
  def update
    if @paper.update(paper_params)
      redirect_to @paper, notice: 'Paper successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /papers/1
  def destroy
    @paper.destroy
    redirect_to papers_url, notice: 'Paper was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def paper_params
      params.require(:paper).permit(:name, :description, :source, :journal, :published_at, :principle_author, :other_authors, :rights, :creator_id, :lab_id, :grant_id, :state)
    end
end
