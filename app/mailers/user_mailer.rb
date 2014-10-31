class UserMailer < ActionMailer::Base
  default from: "john@phaph.com"
  
  # use variable for 'Phaph' and my email
  # preferences for different notifications:
  # - when someone follows you
  # - when someone you follow adds new stuff
  
  # - when someone comments on you or your stuff
  # - when someone copies your stuff
  
  # - never
  
  # Add link to 'manage email preferences' in footer of all emails
  # New comment on one of your collections or collectibles
  # New follower of one of your collections or collectibles
  
  def follow_email(follower, user)
    @user = user
    @follower = follower
    mail(to: @user.email, subject: "You have a new Phaph follower!")
  end
  
  def new_collectible_email(collectible, follower, user)
    @user = user
    @follower = follower
    @collectible = collectible
    mail(to: @user.email, subject: "tk added a new item to Phaph!")
  end
  
  def new_collection_email(collection, follower, user)
    @user = user
    @follower = follower
    @collection = collection
    mail(to: @user.email, subject: "tk added a new collection to Phaph!")
  end
  
  def new_copy_email(collectible, follower, user)
    @user = user
    @follower = follower
    @collectible = collectible
    mail(to: @user.email, subject: "tk copied you item from Phaph!")
  end
  
end
