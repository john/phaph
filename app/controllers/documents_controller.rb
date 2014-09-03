class DocumentsController < ApplicationController
  
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :destroy]
  before_action :set_document, only: [:show, :view, :edit, :update, :destroy]
  
  # GET /documents
  def index
    @model = Document
    @resources = Document.where(:user => current_user).paginate(:page => params[:page])
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
    @collection = @document.collections.first
  end

  # GET /documents/new
  def new
    if params[:collection_id].present?
      @document = Document.new(organization: current_user.organizations.first, collection_id: params[:collection_id])
    else
      @document = Document.new(organization: current_user.organizations.first)
    end
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    @document.state = 'active'
    @document.user = current_user
    
    # should we be storing the full path to the doc in the db?
    
    if @document.url.present?

      # .force_encoding("UTF-8") 


      @document.file_data = open( @document.url ) { |file| file.read }
    else

      # UTF8 FAILS HERE!
      
      logger.debug "---------------------> ABOUT to open uploaded file"

      fd = open( "#{Rails.root}/public#{ @document.file_url }" ) { |file| file.read }
      
      logger.debug "---------------------> JUST opened uploaded file"

      # fd = fd.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '') 
      fd = fd.force_encoding("binary")
      
      logger.debug "---------------------> data is: #{fd.inspect}"

      @document.file_data = fd #.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '') #.force_encoding("UTF-8")
      logger.debug "---------------------> @document.file_data has been set"
    end
    
    if @document.save

      logger.debug "---------------------> @document.save just called"

      if @document.url.present?
        # generate a pdf
        # pdf_out = `wkhtmltopdf #{@document.url}/#{@document.id}.pdf`

        # This gets the site and assets with httrack, zips it,
        # gener
        # move to a job later
        @document.archive_site
      else
        # if a file upload, generate thumbs from pdf,
        # and upload both the pdfs and thumbs to S3
        @document.archive_file
      end
      
      # update document with location of file and thumb
      
      if @document.collection_id.present?
        @collection = Collection.find( @document.collection_id )
      else
        if current_user.collections.size == 0
          @collection = Collection.create!( user: current_user, name: "#{current_user.name}'s documents", state: 'active' )
        else
          redirect_to root_path, alert: 'Something wrong, could not find or create a collection' and return
        end
      end
      collectible = Collectible.where(user: current_user, document: @document, collection: @collection ).first_or_create
      
      if params[:redirect_to].present?
        redirect_to params[:redirect_to]
      else
        redirect_to slugged_document_path(@document, @document.name.parameterize), notice: "Document successfully created. <a href='/documents/new' class='alert-link'>Add another?</a>".html_safe
      end
    else
      render :new
    end
  end

  def view

  end

  # PATCH/PUT /documents/1
  def update
    if @document.update(document_params)
      
      # The .update call above should be handling this. Or the .update_document call below should be.
      # Neither is working though, but .index_document does, and it updates in place rather than
      # creating a new es record. Whatever.
      # @document.__elasticsearch__.update_document
      # @document.__elasticsearch__.index_document
      
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
    
    redirect_to documents_url, notice: 'Document was successfully deleted.'
  end
  
  
  # def search( everything: false )
  #   @model = Document
  #
  #   # https://gist.github.com/jprante/5095527
  #   query = {
  #             query: {
  #               filtered: {
  #                 filter: user_query,
  #                 query: keyword_query( params[:q] )
  #               }
  #             },
  #             highlight: {
  #               fields: {
  #                 attachment: {}
  #               }
  #             }
  #           }
  #
  #   @resources = Document.search( query ).page( params[:page] ||= 1 )
  # end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    
    def set_document
      @document = Document.find(params[:id])
      
      # unless @document.user == current_user
      #   sign_out
      #   redirect_to root_path, alert: "You've been signed out."  and return
      # end
      
    end

    # Only allow a trusted parameter "white list" through.

    # :journal, 
    
    def document_params
      params.require(:document).permit(
      :name, :file, :file_cache, :url, :description, :source, :published_at,
      :principle_authors, :other_authors, :rights, :user_id, :organization_id, :collection_id, :scope,
      :service, :service_id, :service_revision, :service_root, :service_path, :service_modified_at,
      :service_size_in_bytes, :service_mime_type, :state)
    end
end
