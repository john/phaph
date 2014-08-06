require 'rails_helper'

RSpec.describe "organizations/new", :type => :view do
  before(:each) do
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @organization = FactoryGirl.create(:organization)
  end

  it "renders" do
    render
  end
end
