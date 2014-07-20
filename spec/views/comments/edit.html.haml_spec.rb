require 'rails_helper'

RSpec.describe "comments/edit", :type => :view do
  before(:each) do
    # @comment = assign(:comment, Comment.create!())
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @comment = FactoryGirl.create(:comment)
  end

  it "renders" do
    render
  end
end
