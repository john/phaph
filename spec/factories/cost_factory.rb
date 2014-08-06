FactoryGirl.define do
  
  factory :cost do
    name 'A lot. A ton.'
    periodicity Periodicity::ONCE
    
    before(:create) do |cost|
      creator = FactoryGirl.create(:user, email: "lab_user_#{Time.now.to_i + rand(10000)}@foo.com")
      cost.creator_id = creator.id
      cost.user_id = creator.id
      
      org = FactoryGirl.create(:organization)
      cost.organization_id = org.id
      
      grant = FactoryGirl.create(:grant)
      cost.grant_id = grant.id
    end
    
  end
  
end
