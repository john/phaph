FactoryGirl.define do
  
  factory :sample do
    name 'Core #7'
    user_id 1
    lab_id 1
    
    after(:create) do |sample|
      user = FactoryGirl.create(:user, email: "sample_#{Time.now.to_i + rand(10000)}@foo.com")
      sample.user_id = user.id
      
      lab = FactoryGirl.create(:lab)
      sample.lab_id = lab.id
    end
    
  end
  
end
