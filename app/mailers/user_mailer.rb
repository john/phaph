class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default from: "john@phaph.com"
  
  def app_name
    Rails.configuration.x.app_name
  end
  helper_method :app_name
  
  def app_url
    Rails.configuration.x.app_url
  end
  helper_method :app_url
  
  # When someone follows you.
  def follow_user_email(follower, user)
    @user = user
    @follower = follower
    mail(to: @user.email, subject: "You have a new follower on #{app_name} ")
  end
  
  # When someone follows one of your collections.
  def follow_collection_email(follower, collection)
    @collection = collection
    @follower = follower
    mail(to: @collection.user.email, subject: "Your collection '#{@collection.name}' has a new follower!")
  end
  
  # When someone follows one of your collectibles.
  def follow_collectible_email(follower, collectible)
    @collectible = collectible
    @follower = follower
    mail(to: @collectible.user.email, subject: "'#{@collectible.name}' has a new follower!")
  end
  
  # When someone comments on you, or one of your collections or collectibles.
  def comment_email(comment, commenter)
    @comment = comment
    @resource = comment.commentable
    @commenter = commenter
    mail(to: @comment.user.email, subject: "#{commenter.name} commented on '#{view_context.strip_tags(@comment.commentable.name)}'")
  end
  
  # When someone copies one of your collectibles. Called in CollectiblesController#clone
  def copy_email(copyable, copier, user)
    @user = user
    @copier = copier
    @copyable = copyable
    mail(to: @user.email, subject: "#{@copier.name} copied your #{app_name} #{@copyable.class} \"#{@copyable.name}\"!")
  end
  
  
  
  
  
  def like_comment_email(liker, comment)
    
  end
  
  def new_collectible_email(collectible, follower, user)
    @user = user
    @follower = follower
    @collectible = collectible
    mail(to: @user.email, subject: "tk added a new item to #{app_name}!")
  end
  
  def new_collection_email(collection, follower, user)
    @user = user
    @follower = follower
    @collection = collection
    mail(to: @user.email, subject: "tk added a new collection to #{app_name}!")
  end
  
end
