require 'rails_helper'

RSpec.describe "users/index", :type => :view do
  before(:each) do
    assign(:users, [
      FactoryGirl.create(:user),
      FactoryGirl.create(:user, email: 'foo@bar.com')
    ])
  end

  it "renders a list of users" do
    render
  end
end
