require 'rails_helper'

RSpec.describe "authentications/show", :type => :view do
  before(:each) do
    @authentication = assign(:authentication, Authentication.create!(
      :user_id => 1,
      :provider => "Provider",
      :uid => "Uid",
      :access_token => "Access Token",
      :access_token_secret => "Access Token Secret",
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(/1/)
    # expect(rendered).to match(/Provider/)
    # expect(rendered).to match(/Uid/)
    # expect(rendered).to match(/Access Token/)
    # expect(rendered).to match(/Access Token Secret/)
    # expect(rendered).to match(/State/)
  end
end
