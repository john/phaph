FactoryGirl.define do
  
  factory :document do
    name 'A method of blah'
    
    before(:create) do |document|
      user = FactoryGirl.create(:user, email: "document_user_#{Time.now.to_i + rand(10000)}@foo.com")
      document.user_id = user.id
      
      org = FactoryGirl.create(:organization)
      document.organization_id = org.id
    end
    
  end
  
end
