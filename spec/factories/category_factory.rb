FactoryGirl.define do
  
  factory :category do
    name 'Categorical Imperative'
    
    before(:create) do |category|
      creator = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      category.creator_id = creator.id
      
      lab = FactoryGirl.create(:lab)
      category.lab_id = lab.id
    end
    
  end
  
end
