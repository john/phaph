require 'rails_helper'

RSpec.describe Comment, :type => :model do
  
  it { should belong_to (:user) }
  it { should belong_to (:commentable) }
  
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_presence_of :state }
  
end
