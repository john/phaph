require 'rails_helper'

RSpec.describe "searches/new", :type => :view do
  before(:each) do
    assign(:search, Search.new(
      :user_id => 1,
      :term => "MyString",
      :scope => "MyString"
    ))
  end

  it "renders new search form" do
    render
    expect(view).to render_template(:new)
    # assert_select "form[action=?][method=?]", searches_path, "post" do
    #   assert_select "input#search_user_id[name=?]", "search[user_id]"
    #   assert_select "input#search_term[name=?]", "search[term]"
    #   assert_select "input#search_scope[name=?]", "search[scope]"
    # end
  end
end
