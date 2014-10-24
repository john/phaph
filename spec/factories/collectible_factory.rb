FactoryGirl.define do
  
  factory :collectible do
    name 'Important American Documents, the collectible'
    
    before(:create) do |collectible|
      document = FactoryGirl.create(:document)
      collection = FactoryGirl.create(:collection)
      collectible.document = document
      collectible.collection = collection
      collectible.user = collection.user
    end
    
  end
  
end
