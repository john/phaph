class CommentsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :like, :unlike]
  
  def like
    if request.xhr?
      current_user.like!(@comment)
      @comment.create_activity :like, owner: current_user
    
      # if @comment.user.settings(:notify).on_comment == 'yes'
      #   # like_comment_email(liker, comment)
      #   UserMailer.like_comment_email(current_user, @comment).deliver_later
      # end
      
    end
  end

  def unlike
    current_user.unlike!(@comment)
    
    @activity = PublicActivity::Activity.where(trackable_id: @comment, trackable_type: @comment.class.to_s, key: 'comment.like')
    @activity.destroy_all 
    
    render template: 'comments/like'
  end
  
  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    if comment = params[:comment]
      resource = Object.const_get( comment[:commentable_type] ).find( comment[:commentable_id] )
      @comment = Comment.build_from( resource, current_user.id, comment[:body] )
      
      if @comment.save
        @comment.create_activity :create, owner: current_user
        
        if resource.user.settings(:notify).on_comment == 'yes' && resource.user != current_user
          UserMailer.comment_email(@comment, resource.user).deliver_later
        end
        
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    # redirect_to comments_url, notice: 'Comment was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params[:commentable_id, :commentable_type, :title, :body, :subject, :user_id, :parent_id]
    end
end
