require 'rails_helper'

RSpec.describe "collections/edit", :type => :view do
  before(:each) do
    @collection = assign(:collection, Collection.create!(
      :name => "MyString",
      :description => "MyText",
      :state => "MyString"
    ))
  end

  it "renders the edit collection form" do
    render

    assert_select "form[action=?][method=?]", collection_path(@collection), "post" do

      assert_select "input#collection_name[name=?]", "collection[name]"

      assert_select "textarea#collection_description[name=?]", "collection[description]"

      assert_select "input#collection_state[name=?]", "collection[state]"
    end
  end
end
