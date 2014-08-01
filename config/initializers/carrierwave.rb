# # CarrierWave.configure do |config|
# #   config.dropbox_app_key = ENV["APP_KEY"]
# #   config.dropbox_app_secret = ENV["APP_SECRET"]
# #   config.dropbox_access_token = ENV["ACCESS_TOKEN"]
# #   config.dropbox_access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
# #   config.dropbox_user_id = ENV["USER_ID"]
# #   config.dropbox_access_type = "dropbox"
# # end
#
# # rake dropbox:authorize APP_KEY='jtgzmeyw4zj2pxb' APP_SECRET='mc0yzmdeudwmr2m' ACCESS_TYPE=dropbox
#
# # then follow directions--you need to hit a url, then continue on the cli, which will give you the
# # token and token secret. you'll have to figure out how to do that programmtically in the finished
# # app--i'm guessing standard oauth back and forth
#
# # access_token: yjfyzdrrnfzaxv1n
# # access_token_secret: 0rxjyqwxwccaf0d
# # user_id: 21335485
#
#
# API = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
#
# CarrierWave.configure do |config|
#
#   # config.dropbox_app_key = 'jtgzmeyw4zj2pxb'
#   config.dropbox_app_key = API['dropbox']['key']
#
#   # config.dropbox_app_secret = 'mc0yzmdeudwmr2m'
#   config.dropbox_app_secret = API['dropbox']['secret']
#
#   # config.dropbox_access_token = '2js3apc8a3y8mc2u'
#
#   # this should come through oauth, but you can get it on the command line
#   # config.dropbox_access_token_secret = 'zax7jo2one72txe'
#   config.dropbox_access_token_secret = ''
#
#   # config.dropbox_user_id = '21335485'
#   config.dropbox_access_type = "dropbox"
# end
#
#
# module CarrierWave::Uploader::Cache
#
#   def full_cache_path
#     "#{::Rails.root}/public/#{cache_dir}/#{cache_name}"
#   end
#
# end