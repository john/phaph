require 'rails_helper'

RSpec.describe "comments/new", :type => :view do
  before(:each) do
    # assign(:comment, Comment.new())
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @comment = FactoryGirl.create(:comment)
  end

  it "renders" do
    render

    # assert_select "form[action=?][method=?]", comments_path, "post" do
    # end
  end
end
