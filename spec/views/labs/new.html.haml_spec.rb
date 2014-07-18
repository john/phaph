require 'rails_helper'

RSpec.describe "labs/new", :type => :view do
  before(:each) do
    # assign(:lab, Lab.new())
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @lab = FactoryGirl.create(:lab)
  end

  it "renders" do
    render

    # assert_select "form[action=?][method=?]", labs_path, "post" do
    # end
  end
end
