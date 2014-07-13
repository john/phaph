require 'rails_helper'

RSpec.describe "costs/new", :type => :view do
  before(:each) do
    assign(:cost, Cost.new(
      :name => "MyString",
      :description => "MyText",
      :amount => "9.99",
      :creator_id => 1,
      :user_id => 1,
      :lab_id => 1,
      :grant_id => 1,
      :category_id => 1,
      :periodicity => 1,
      :state => "MyString"
    ))
  end

  it "renders new cost form" do
    render

    assert_select "form[action=?][method=?]", costs_path, "post" do

      assert_select "input#cost_name[name=?]", "cost[name]"

      assert_select "textarea#cost_description[name=?]", "cost[description]"

      assert_select "input#cost_amount[name=?]", "cost[amount]"

      assert_select "input#cost_creator_id[name=?]", "cost[creator_id]"

      assert_select "input#cost_user_id[name=?]", "cost[user_id]"

      assert_select "input#cost_lab_id[name=?]", "cost[lab_id]"

      assert_select "input#cost_grant_id[name=?]", "cost[grant_id]"

      assert_select "input#cost_category_id[name=?]", "cost[category_id]"

      assert_select "input#cost_periodicity[name=?]", "cost[periodicity]"

      assert_select "input#cost_state[name=?]", "cost[state]"
    end
  end
end
