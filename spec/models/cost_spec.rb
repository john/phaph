require 'rails_helper'

RSpec.describe Cost, :type => :model do

  it { should belong_to (:creator) }
  it { should belong_to (:lab) }
  it { should belong_to (:grant) }
  
  it { should validate_presence_of :name }
  it { should validate_presence_of :creator }
  it { should validate_presence_of :lab }
  it { should validate_presence_of :state }
  
end
