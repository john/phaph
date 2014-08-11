class DocumentsController < ApplicationController
  
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :destroy]
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  
  # GET /documents
  def index
    @model = Document
    @resources = Document.paginate(:page => params[:page])
    # render :template => '/shared/resource/index'
  end
  
  # GET /imports
  def import
    if signed_in?
      client = DropboxClient.new( current_user.authentications.first.token )
      @dropbox = client.metadata('/')
    end
  end

  # GET /documents/1
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new(organization: current_user.organizations.first)
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    @document.user_id = current_user.id
    @document.file_data = open( "#{Rails.root}/public#{ @document.file_url }" ) { |file| file.read }
    
    if @document.save
      # ImageScience.with_image file do |@document.file_data|
      #   img.cropped_thumbnail 100 do |thumb|
      #     thumb.save "#{file}_cropped.png"
      #   end
      #
      #   img.thumbnail 100 do |thumb|
      #     thumb.save "#{file}_thumb.png"
      #   end
      # end
      image = MiniMagick::Image.read( "#{Rails.root}/public#{ @document.file_url }" )
      image.resize "425x550"
      image.write  "output.jpg"
      
      
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
    if @document.update(document_params)
      
      # The .update call above should be handling this. Or the .update_document call below should be.
      # Neither is working though, but .index_document does, and it updates in place rather than
      # creating a new es record. Whatever.
      # @document.__elasticsearch__.update_document
      @document.__elasticsearch__.index_document
      
      redirect_to @document, notice: 'Document successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /documents/1
  def destroy
    
    # add a conditional so that removal from dropbox is optional
    # also remove from dropbox?
    if @document.service_path.present?
      client = DropboxClient.new( current_user.authentications.first.token )
      client.file_delete( @document.service_path )
    end
    
    @document.destroy
    
    redirect_to documents_url, notice: 'Document was successfully destroyed.'
  end
  
  
  def search( everything: false )
    @model = Document

    # https://gist.github.com/jprante/5095527
    query = {
              query: {
                filtered: {
                  filter: user_query,
                  query: keyword_query( params[:q] )
                }
              },
              highlight: {
                fields: {
                  attachment: {}
                }
              }
            }
            
    @resources = Document.search( query ).page( params[:page] ||= 1 )
  end
  
  
  def user_query
    if true
      return {
        term: {
          user_id: "#{current_user.id}"
        }
      }
    else
      return {}
    end
  end
  
  
  def keyword_query( q )
    return {
      multi_match: {
        query: "#{q}",
        fields: ["attachment", "name", "description", "source"]
      }
    }
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def document_params
      params.require(:document).permit(
      :name, :file, :file_cache, :description, :source, :journal, :published_at,
      :principle_authors, :other_authors, :rights, :user_id, :organization_id, :grant_id, :scope,
      :service, :service_id, :service_revision, :service_root, :service_path, :service_modified_at,
      :service_size_in_bytes, :service_mime_type, :state)
    end
end
