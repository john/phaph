require 'rails_helper'

RSpec.describe "users/show", :type => :view do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    view.stub(:atomic_unit).and_return('blarg')
    view.stub(:current_user).and_return(@user)
    view.stub(:signed_in?).and_return(true)
  end

  it "renders" do
    render
  end

end
