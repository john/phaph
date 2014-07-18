require 'rails_helper'

RSpec.describe "labs/edit", :type => :view do
  before(:each) do
    # @lab = assign(:lab, Lab.create!())
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @lab = FactoryGirl.create(:lab)
  end

  it "renders the edit lab form" do
    render

    # assert_select "form[action=?][method=?]", lab_path(@lab), "post" do
    # end
  end
end
