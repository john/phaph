FactoryGirl.define do
  
  factory :sample do
    name 'Core #7'
    user_id 1
    organization_id 1
    
    after(:create) do |sample|
      user = FactoryGirl.create(:user, email: "sample_#{Time.now.to_i + rand(10000)}@foo.com")
      sample.user_id = user.id
      
      org = FactoryGirl.create(:organization)
      sample.organization_id = org.id
    end
    
  end
  
end
