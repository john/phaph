FactoryGirl.define do
  
  factory :lab do
    name 'Acme Labs'
    
    before(:create) do |lab|
      creator = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      lab.creator_id = creator.id
    end
    
  end
  
end
