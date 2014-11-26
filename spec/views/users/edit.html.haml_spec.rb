require 'rails_helper'

RSpec.describe "users/edit", :type => :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it "renders the edit user form" do
    render

    expect(view).to render_template(:edit)
    # assert_select "form[action=?][method=?]", user_path(@user), "post" do
    # end
  end
end
