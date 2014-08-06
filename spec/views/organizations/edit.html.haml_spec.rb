require 'rails_helper'

RSpec.describe "organizations/edit", :type => :view do
  before(:each) do
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @organization = FactoryGirl.create(:organization)
  end

  it "renders the edit organization form" do
    render
  end
end
