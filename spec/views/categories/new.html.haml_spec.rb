require 'rails_helper'

RSpec.describe "categories/new", :type => :view do
  before(:each) do
    assign(:category, Category.new(
      :name => "MyString",
      :description => "MyText",
      :creator_id => 1,
      :lab_id => 1,
      :grant_id => 1,
      :state => "MyString"
    ))
  end

  it "renders new category form" do
    render

    assert_select "form[action=?][method=?]", categories_path, "post" do

      assert_select "input#category_name[name=?]", "category[name]"

      assert_select "textarea#category_description[name=?]", "category[description]"

      assert_select "input#category_creator_id[name=?]", "category[creator_id]"

      assert_select "input#category_lab_id[name=?]", "category[lab_id]"

      assert_select "input#category_grant_id[name=?]", "category[grant_id]"

      assert_select "input#category_state[name=?]", "category[state]"
    end
  end
end
