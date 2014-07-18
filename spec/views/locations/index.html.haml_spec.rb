require 'rails_helper'

RSpec.describe "locations/index", :type => :view do
  before(:each) do
    assign(:locations, [
      # Location.create!(
      #   :name => "Name",
      #   :latitude => "9.99",
      #   :longitude => "9.99",
      #   :city => "City",
      #   :state => "State",
      #   :country => "Country",
      #   :administrative_level => "Administrative Level"
      # ),
      # Location.create!(
      #   :name => "Name",
      #   :latitude => "9.99",
      #   :longitude => "9.99",
      #   :city => "City",
      #   :state => "State",
      #   :country => "Country",
      #   :administrative_level => "Administrative Level"
      # )
      FactoryGirl.create(:location),
      FactoryGirl.create(:location)
    ])
  end

  it "renders a list of locations" do
    render
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # assert_select "tr>td", :text => "City".to_s, :count => 2
    # assert_select "tr>td", :text => "State".to_s, :count => 2
    # assert_select "tr>td", :text => "Country".to_s, :count => 2
    # assert_select "tr>td", :text => "Administrative Level".to_s, :count => 2
  end
end
