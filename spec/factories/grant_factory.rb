FactoryGirl.define do
  
  factory :grant do
    name 'carey'
    
    before(:create) do |grant|
      creator = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      grant.creator_id = creator.id
      
      lab = FactoryGirl.create(:lab)
      grant.lab_id = lab.id
    end
    
  end
  
end
