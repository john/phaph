class DocumentsController < ApplicationController
  
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :destroy, :follow, :unfollow]
  before_action :set_document, only: [:show, :view, :edit, :update, :destroy, :follow, :unfollow]
  
  def follow
    current_user.follow!(@document)
  end

  def unfollow
    current_user.unfollow!(@document)
    render template: 'documents/follow'
  end
  
  # GET /documents
  def index
    @title = 'Documents'
    @model = Document
    @resources = Document.where(:user => current_user).paginate(:page => params[:page])
  end
  
  # # GET /imports
  # def import
  #   if signed_in?
  #     client = DropboxClient.new( current_user.authentications.first.token )
  #     @dropbox = client.metadata('/')
  #   end
  # end

  # GET /documents/1
  def show
    @title = @document.name
    @collection = @document.collection
  end

  # GET /documents/new
  def new
    unless current_user.has_collections?
      redirect_to new_collection_path, notice: "#{atomic_unit}s go in collections. <b class='alert-link'>Creat a collection below.</b>"
    end

    @title = "New document"
    if params[:collection_id].present?
      @collection = Collection.find(params[:collection_id])
      
      # Don't allow access to non-public docs the user doesn't own
      if !@collection.public? && !@collection.owned_by?(current_user)
        redirect_to root_path and return
      end

      @selected_collection_id = @collection.id
      @document = Document.new(collection: @collection)

    else
      @document = Document.new
    end
  end

  # GET /documents/1/edit
  def edit
    @title = "Edit #{@document.name}"
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    @document.state = 'active'
    @document.user = current_user
    
    if @document.url.present?
      @document.file_data = open( @document.url ) { |file| file.read }
    else
      fd = open( "#{Rails.root}/public#{ @document.file_url }" ) { |file| file.read }
      fd = fd.force_encoding("binary")
      
      @document.file_data = fd
    end
    
    if @document.save

      # CreateDocumentJob.enqueue( @document, current_user )
      if @document.url.present?
        # generate a pdf
        # pdf_out = `wkhtmltopdf #{@document.url}/#{@document.id}.pdf`

        @document.archive_site
      else
        # if a file upload, generate thumbs from pdf,
        # and upload both the pdfs and thumbs to S3
        @document.archive_file
      end

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
        redirect_to slugged_document_path(@document.id, @document.slug), notice: "#{atomic_unit} successfully created. <a href='/documents/new?collection_id=#{@collection.id}' class='alert-link'>Add another?</a>".html_safe
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
      # @document.__elasticsearch__.index_document
      
      redirect_to @document, notice: 'Site successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /documents/1
  def destroy
    
    # add a conditional so that removal from dropbox is optional
    # also remove from dropbox?
    # if @document.service_path.present?
    #   client = DropboxClient.new( current_user.authentications.first.token )
    #   client.file_delete( @document.service_path )
    # end
    
    @document.destroy
    
    # documents_url
    redirect_to user_path(current_user), notice: "#{atomic_unit} was successfully deleted."
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    
    def set_document
      @document = Document.friendly.find(params[:id])
      
      # unless @document.user == current_user
      #   sign_out
      #   redirect_to root_path, alert: "You've been signed out."  and return
      # end
    end

    # :journal, 
    
    def document_params
      params.require(:document).permit(
      :name, :file, :file_cache, :url, :description, :source, :published_at,
      :principle_authors, :other_authors, :rights, :user_id, :collection_id, :scope,
      :service, :service_id, :service_revision, :service_root, :service_path, :service_modified_at,
      :service_size_in_bytes, :service_mime_type, :state)
    end
end
