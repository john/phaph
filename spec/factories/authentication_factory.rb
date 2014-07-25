FactoryGirl.define do
  
  factory :authentication do
    user_id 1
    provider 'dropbox'
    uid 12345
    token 678
    secret 91011
    state 'good'
  end
  
end
