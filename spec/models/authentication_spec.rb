require 'rails_helper'

RSpec.describe Authentication, :type => :model do
  
  it { should belong_to (:user) }
  
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :state }
  
end
