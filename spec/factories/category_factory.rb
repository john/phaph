FactoryGirl.define do
  
  factory :category do
    name 'Categorical Imperative'
    
    before(:create) do |category|
      user = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      category.user_id = user.id
      
      org = FactoryGirl.create(:organization)
      category.organization_id = org.id
    end
    
  end
  
end
