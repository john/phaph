require 'rails_helper'

RSpec.describe Grant, :type => :model do
  
  it { should belong_to (:user) }
  it { should belong_to (:lab) }
  it { should have_many (:categories) }
  it { should have_many (:costs) }
  
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
  it { should validate_presence_of :lab }
  it { should validate_presence_of :state }
  
end
