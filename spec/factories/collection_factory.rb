FactoryGirl.define do
  
  factory :collection do
    name 'Important American Documents'
    
    before(:create) do |collection|
      user = FactoryGirl.create(:user, email: "collection_user_#{Time.now.to_i + rand(10000)}@foo.com")
      collection.user_id = user.id
    end
    
  end
  
end
