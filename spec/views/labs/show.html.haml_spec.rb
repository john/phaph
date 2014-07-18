require 'rails_helper'

RSpec.describe "labs/show", :type => :view do
  before(:each) do
    # @lab = assign(:lab, Lab.create!())
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @lab = FactoryGirl.create(:lab)
  end

  it "renders" do
    render
  end
end
