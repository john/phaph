FactoryGirl.define do
  
  factory :comment do
    body 'Commenting commenting blah blah'
    
    before(:create) do |comment|
      user = FactoryGirl.create(:user, email: "paper_user_#{Time.now.to_i + rand(10000)}@foo.com")
      comment.user_id = user.id
    end
    
  end
  
end
