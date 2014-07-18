require 'rails_helper'

RSpec.describe "users/show", :type => :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "renders attributes in <p>" do
    render
  end
end
