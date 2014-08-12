require 'rails_helper'

RSpec.describe Organization, :type => :model do
  
  it { should belong_to (:user) }
  # it { should have_many (:memberships) }
  it { should have_many (:documents) }
  it { should have_many (:presences) }
  it { should have_many (:locations) }
  
  it { should validate_presence_of :name }
  
end
