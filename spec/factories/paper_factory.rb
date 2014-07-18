FactoryGirl.define do
  
  factory :paper do
    name 'A method of blah'
    
    before(:create) do |paper|
      creator = FactoryGirl.create(:user, email: "paper_user_#{Time.now.to_i + rand(10000)}@foo.com")
      paper.creator_id = creator.id
      
      lab = FactoryGirl.create(:lab)
      paper.lab_id = lab.id
    end
    
  end
  
end
