FactoryGirl.define do
  
  factory :grant do
    name 'carey'
    
    before(:create) do |grant|
      user = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      grant.user_id = user.id
      
      lab = FactoryGirl.create(:lab)
      grant.lab_id = lab.id
    end
    
  end
  
end
