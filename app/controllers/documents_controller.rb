class DocumentsController < ApplicationController
  
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :destroy]
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  def index
    @model = Document
    @resources = Document.all
    render :template => '/shared/resource/index'
  end

  # GET /documents/1
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new(lab: current_user.labs.first)
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    @document.user_id = current_user.id
    
    if @document.save
      # redirect_to @document, notice: 'Document was successfully created.'
      if params[:redirect_to].present?
        redirect_to params[:redirect_to]
      else
        redirect_to @document, notice: 'Document successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /documents/1
  def update
    if @document.update(paper_params)
      redirect_to @document, notice: 'Document successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy
    redirect_to documents_url, notice: 'Document was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def document_params
      params.require(:document).permit(:name, :file, :file_cache, :description, :source, :journal, :published_at, :principle_authors, :other_authors, :rights, :user_id, :lab_id, :grant_id, :scope, :state)
    end
end
