require 'rails_helper'

RSpec.describe "authentications/new", :type => :view do
  before(:each) do
    assign(:authentication, Authentication.new(
      :user_id => 1,
      :provider => "MyString",
      :uid => "MyString",
      :access_token => "MyString",
      :access_token_secret => "MyString",
      :state => "MyString"
    ))
  end

  it "renders new authentication form" do
    render

    # assert_select "form[action=?][method=?]", authentications_path, "post" do
    #
    #   assert_select "input#authentication_user_id[name=?]", "authentication[user_id]"
    #
    #   assert_select "input#authentication_provider[name=?]", "authentication[provider]"
    #
    #   assert_select "input#authentication_uid[name=?]", "authentication[uid]"
    #
    #   assert_select "input#authentication_access_token[name=?]", "authentication[access_token]"
    #
    #   assert_select "input#authentication_access_token_secret[name=?]", "authentication[access_token_secret]"
    #
    #   assert_select "input#authentication_state[name=?]", "authentication[state]"
    # end
  end
end
