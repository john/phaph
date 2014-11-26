require 'rails_helper'

RSpec.describe "searches/edit", :type => :view do
  before(:each) do
    @search = assign(:search, Search.create!(
      :user_id => 1,
      :term => "MyString",
      :scope => "MyString"
    ))
  end

  it "renders the edit search form" do
    render
    
    expect(view).to render_template(:edit)
    # assert_select "form[action=?][method=?]", search_path(@search), "post" do
    #   assert_select "input#search_user_id[name=?]", "search[user_id]"
    #   assert_select "input#search_term[name=?]", "search[term]"
    #   assert_select "input#search_scope[name=?]", "search[scope]"
    # end
  end
end
