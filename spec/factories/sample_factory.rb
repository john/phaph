FactoryGirl.define do
  
  factory :sample do
    name 'Core #7'
    creator_id 1
    lab_id 1
    
    after(:create) do |sample|
      creator = FactoryGirl.create(:user, email: "sample_#{Time.now.to_i + rand(10000)}@foo.com")
      sample.creator_id = creator.id
      
      lab = FactoryGirl.create(:lab)
      sample.lab_id = lab.id
    end
    
  end
  
end
