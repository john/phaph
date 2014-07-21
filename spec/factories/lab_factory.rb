FactoryGirl.define do
  
  factory :lab do
    name 'Acme Labs'
    
    before(:create) do |lab|
      user = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      lab.user_id = user.id
    end
    
  end
  
end
