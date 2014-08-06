FactoryGirl.define do
  
  factory :grant do
    name 'carey'
    
    before(:create) do |grant|
      user = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      grant.user_id = user.id
      
      org = FactoryGirl.create(:organization)
      grant.organization_id = org.id
    end
    
  end
  
end
