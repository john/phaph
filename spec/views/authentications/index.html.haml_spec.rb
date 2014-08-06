require 'rails_helper'

RSpec.describe "authentications/index", :type => :view do
  before(:each) do
    assign(:authentications, [
      Authentication.create!(
        :user_id => 1,
        :provider => "Provider",
        :uid => "12",
        # :access_token => "Access Token",
        # :access_token_secret => "Access Token Secret",
        :state => "active"
      ),
      Authentication.create!(
        :user_id => 1,
        :provider => "Provider",
        :uid => "23",
        # :access_token => "Access Token",
        # :access_token_secret => "Access Token Secret",
        :state => "active"
      )
    ])
  end

  it "renders a list of authentications" do
    render
    # assert_select "tr>td", :text => 1.to_s, :count => 2
    # assert_select "tr>td", :text => "Provider".to_s, :count => 2
    # assert_select "tr>td", :text => "Uid".to_s, :count => 2
    # assert_select "tr>td", :text => "Access Token".to_s, :count => 2
    # assert_select "tr>td", :text => "Access Token Secret".to_s, :count => 2
    # assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
