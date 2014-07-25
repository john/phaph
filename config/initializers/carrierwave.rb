# CarrierWave.configure do |config|
#   config.dropbox_app_key = ENV["APP_KEY"]
#   config.dropbox_app_secret = ENV["APP_SECRET"]
#   config.dropbox_access_token = ENV["ACCESS_TOKEN"]
#   config.dropbox_access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
#   config.dropbox_user_id = ENV["USER_ID"]
#   config.dropbox_access_type = "dropbox"
# end

# rake dropbox:authorize APP_KEY='jtgzmeyw4zj2pxb' APP_SECRET='mc0yzmdeudwmr2m' ACCESS_TYPE=dropbox
# then follow directions--you need to hit a url, then continue on the cli, which will give you the
# token and token secret. you'll have to figure out how to do that programmtically in the finished
# app--i'm guessing standard oauth back and forth

# access_token: yjfyzdrrnfzaxv1n
# access_token_secret: 0rxjyqwxwccaf0d
# user_id: 21335485

CarrierWave.configure do |config|
  
  # these three from the dropbox app dashboar
  config.dropbox_app_key = 'jtgzmeyw4zj2pxb'
  config.dropbox_app_secret = 'mc0yzmdeudwmr2m'
  config.dropbox_access_token = 'yjfyzdrrnfzaxv1n'
  
  # this should come through oauth, but you can get it on the command line
  config.dropbox_access_token_secret = '0rxjyqwxwccaf0d'
  
  # user_id i figured out by looking at files in my dropbox
  config.dropbox_user_id = '21335485'
  
  config.dropbox_access_type = "dropbox"
end