require 'rails_helper'

RSpec.describe "authentications/show", :type => :view do
  before(:each) do
    @authentication = assign(:authentication, Authentication.create!(
      :user_id => 1,
      :provider => "Provider",
      :uid => "Uid",
      # :access_token => "Access Token",
      # :access_token_secret => "Access Token Secret",
      :state => "active"
    ))
  end

  it "renders attributes in <p>" do
    render
  end
end
