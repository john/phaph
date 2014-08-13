FactoryGirl.define do
  
  factory :document do
    name 'A method of blah'
    
    before(:create) do |document|
      
      # unless document.user_id.present?
        user = FactoryGirl.create(:user, email: "document_user_#{Time.now.to_i + rand(10000)}@foo.com")
        document.user_id = user.id
      # end
      
      org = FactoryGirl.create(:organization)
      document.organization_id = org.id
    end
    
  end
  
end
