require 'rails_helper'

RSpec.describe Document, :type => :model do
  
  it { should belong_to (:user) }
  
  it { should validate_presence_of :name }
  it { should validate_presence_of :state }
  
end
