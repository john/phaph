FactoryGirl.define do
  
  factory :document do
    name 'A method of blah'
    
    before(:create) do |document|
      creator = FactoryGirl.create(:user, email: "document_user_#{Time.now.to_i + rand(10000)}@foo.com")
      document.creator_id = creator.id
      
      lab = FactoryGirl.create(:lab)
      document.lab_id = lab.id
    end
    
  end
  
end
