require 'rails_helper'

RSpec.describe Presence, :type => :model do
  it { should belong_to (:location) }
  it { should belong_to (:locatable) }
end
