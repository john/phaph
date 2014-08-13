FactoryGirl.define do
  
  factory :user do
    name 'Louis Renault'
    username 'louis'
    email 'louis@vichy.fr'
    password 'abc123!@#'
    confirmed_at '2014-01-01'
  end
  
end
