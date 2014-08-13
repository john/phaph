require 'rails_helper'

RSpec.describe "collections/edit", :type => :view do
  before(:each) do
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @collection = FactoryGirl.create(:collection)
  end

  it "renders" do
    render
  end
end
