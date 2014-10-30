class UserMailer < ActionMailer::Base
  default from: "john@wordie.org"
  
  def follow_email(follower, followee)
    @user = followee
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: "You have a new Phaph follower!")
  end
  
end
