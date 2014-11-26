FactoryGirl.define do
  
  factory :document do
    name 'A method of blah'
    url 'http://foo.com'
    
    before(:create) do |document|
      user = FactoryGirl.create(:user, email: "document_user_#{Time.now.to_i + rand(10000)}@foo.com")
      document.user_id = user.id
    end
    
  end
  
end
