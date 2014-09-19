require 'rails_helper'

RSpec.describe "locations/index", :type => :view do
  before(:each) do
    assign(:locations, [
      FactoryGirl.create(:location),
      FactoryGirl.create(:location)
    ])
  end

  it "renders a list of locations" do
    render
  end
end
