require 'rails_helper'

RSpec.describe "authentications/edit", :type => :view do
  before(:each) do
    @authentication = assign(:authentication, Authentication.create!(
      :user_id => 1,
      :provider => "MyString",
      :uid => "MyString",
      # :access_token => "MyString",
      # :access_token_secret => "MyString",
      :state => "active"
    ))
  end

  it "renders the edit authentication form" do
    render
  end
end
