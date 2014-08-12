require 'rails_helper'

RSpec.describe "collections/new", :type => :view do
  before(:each) do
    assign(:collection, Collection.new(
      :name => "MyString",
      :description => "MyText",
      :state => "MyString"
    ))
  end

  it "renders new collection form" do
    render

    assert_select "form[action=?][method=?]", collections_path, "post" do

      assert_select "input#collection_name[name=?]", "collection[name]"

      assert_select "textarea#collection_description[name=?]", "collection[description]"

      assert_select "input#collection_state[name=?]", "collection[state]"
    end
  end
end
