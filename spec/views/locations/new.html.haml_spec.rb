require 'rails_helper'

RSpec.describe "locations/new", :type => :view do
  before(:each) do
    # assign(:location, Location.new(
   #    :name => "MyString",
   #    :latitude => "9.99",
   #    :longitude => "9.99",
   #    :city => "MyString",
   #    :state => "MyString",
   #    :country => "MyString",
   #    :administrative_level => "MyString"
   #  ))
   john = FactoryGirl.create(:user)
   view.stub(:current_user).and_return(john)
   @location = FactoryGirl.create(:location)
  end

  it "renders" do
    render

    # assert_select "form[action=?][method=?]", locations_path, "post" do
    #
    #   assert_select "input#location_name[name=?]", "location[name]"
    #
    #   assert_select "input#location_latitude[name=?]", "location[latitude]"
    #
    #   assert_select "input#location_longitude[name=?]", "location[longitude]"
    #
    #   assert_select "input#location_city[name=?]", "location[city]"
    #
    #   assert_select "input#location_state[name=?]", "location[state]"
    #
    #   assert_select "input#location_country[name=?]", "location[country]"
    #
    #   assert_select "input#location_administrative_level[name=?]", "location[administrative_level]"
    # end
  end
end
