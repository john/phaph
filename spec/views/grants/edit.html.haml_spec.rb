require 'rails_helper'

RSpec.describe "grants/edit", :type => :view do
  before(:each) do
    @grant = assign(:grant, Grant.create!(
      :name => "MyString",
      :description => "MyText",
      :source => "MyString",
      :amount => "9.99",
      :overhead => 1.5,
      :user_id => 1,
      :lab_id => 1,
      :state => "MyString"
    ))
  end

  it "renders the edit grant form" do
    render

    assert_select "form[action=?][method=?]", grant_path(@grant), "post" do

      assert_select "input#grant_name[name=?]", "grant[name]"

      assert_select "textarea#grant_description[name=?]", "grant[description]"

      assert_select "input#grant_source[name=?]", "grant[source]"

      assert_select "input#grant_amount[name=?]", "grant[amount]"

      assert_select "input#grant_overhead[name=?]", "grant[overhead]"

      assert_select "input#grant_user_id[name=?]", "grant[user_id]"

      assert_select "input#grant_lab_id[name=?]", "grant[lab_id]"

      assert_select "input#grant_state[name=?]", "grant[state]"
    end
  end
end
