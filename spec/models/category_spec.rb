require 'rails_helper'

RSpec.describe Category, :type => :model do
  
  it { should belong_to (:user) }
  it { should belong_to (:lab) }
  it { should belong_to (:grant) }
  
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
  it { should validate_presence_of :lab }
  it { should validate_presence_of :state }
  
end
