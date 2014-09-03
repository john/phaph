class Search < ActiveRecord::Base
  
  belongs_to :organization
  belongs_to :user
  
  enum state: { active: 0, inactive: 1 }
  
end
