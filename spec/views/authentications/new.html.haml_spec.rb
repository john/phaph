require 'rails_helper'

RSpec.describe "authentications/new", :type => :view do
  before(:each) do
    assign(:authentication, Authentication.new(
      :user_id => 1,
      :provider => "MyString",
      :uid => "MyString",
      # :access_token => "MyString",
      # :access_token_secret => "MyString",
      :state => "MyString"
    ))
  end

  it "renders new authentication form" do
    render
  end
end
