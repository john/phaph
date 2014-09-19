require 'rails_helper'

RSpec.describe "users/index", :type => :view do
  before(:each) do
    user1 = FactoryGirl.create(:user)
    assign(:users, [
      user1,
      FactoryGirl.create(:user, email: 'foo@bar.com')
    ])
    view.stub(:current_user).and_return( user1 )
    view.stub(:signed_in?).and_return(true)
  end

  it "renders a list of users" do
    render
  end
end
