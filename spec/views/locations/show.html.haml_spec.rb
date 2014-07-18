require 'rails_helper'

RSpec.describe "locations/show", :type => :view do
  before(:each) do
    # @location = assign(:location, Location.create!(
    #   :name => "Name",
    #   :latitude => "9.99",
    #   :longitude => "9.99",
    #   :city => "City",
    #   :state => "State",
    #   :country => "Country",
    #   :administrative_level => "Administrative Level"
    # ))
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @location = FactoryGirl.create(:location)
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(/Name/)
    # expect(rendered).to match(/9.99/)
    # expect(rendered).to match(/9.99/)
    # expect(rendered).to match(/City/)
    # expect(rendered).to match(/State/)
    # expect(rendered).to match(/Country/)
    # expect(rendered).to match(/Administrative Level/)
  end
end
