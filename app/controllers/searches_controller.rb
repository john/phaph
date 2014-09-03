class SearchesController < ApplicationController
  # before_action :set_search, only: [:show, :edit, :update, :destroy]

  # # GET /searches
  # def index
  #   @searches = Search.all
  # end
  #
  # # GET /searches/1
  # def show
  # end

  # # GET /searches/new
  # def new
  #   @search = Search.new
  # end
  
  
  
  def show
    @model = Document

    # https://gist.github.com/jprante/5095527
    query = {
              query: {
                filtered: {
                  filter: user_query( (params[:search_scope] && params[:search_scope].downcase == 'yours') ? current_user.id : nil ),
                  query: keyword_query( params[:q] )
                }
              },
              highlight: {
                fields: {
                  attachment: {}
                }
              }
            }
            
    @scope = (params[:search_scope].present? && params[:search_scope].downcase == 'yours') ? 'yours' : 'all'
    @resources = Document.search( query ).page( params[:page] ||= 1 )
  end
  
  
  # # GET /searches/1/edit
  # def edit
  # end
  #
  # # POST /searches
  # def create
  #   @search = Search.new(search_params)
  #
  #   if @search.save
  #     redirect_to @search, notice: 'Search was successfully created.'
  #   else
  #     render :new
  #   end
  # end
  #
  # # PATCH/PUT /searches/1
  # def update
  #   if @search.update(search_params)
  #     redirect_to @search, notice: 'Search was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end
  #
  # # DELETE /searches/1
  # def destroy
  #   @search.destroy
  #   redirect_to searches_url, notice: 'Search was successfully destroyed.'
  # end
  #
  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_search
  #     @search = Search.find(params[:id])
  #   end

  # Only allow a trusted parameter "white list" through.
  def search_params
    params.require(:search).permit(:user_id, :organization_id, :name, :description, :term, :scope)
  end
  
  private
  
  def user_query( user_id=nil )
    if user_id.present?
      return {
        term: {
          user_id: "#{user_id}"
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
  
end