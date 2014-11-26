require 'rails_helper'

RSpec.describe "documents/edit", :type => :view do
  before(:each) do

    # john = FactoryGirl.create(:user)
    john = create(:user)
    view.stub(:current_user).and_return(john)
    @document = FactoryGirl.create(:document)
  end

  it "renders" do
    render
  end
end
