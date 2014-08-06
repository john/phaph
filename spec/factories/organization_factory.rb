FactoryGirl.define do
  
  factory :organization do
    name 'Acme Labs'
    
    before(:create) do |organization|
      user = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      organization.user_id = user.id
    end
    
  end
  
end
