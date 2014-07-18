require 'rails_helper'

RSpec.describe "costs/index", :type => :view do
  before(:each) do
    assign(:costs, [
      # Cost.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :amount => "9.99",
      #   :creator_id => 1,
      #   :user_id => 2,
      #   :lab_id => 3,
      #   :grant_id => 4,
      #   :category_id => 5,
      #   :periodicity => 6,
      #   :state => "State"
      # ),
      # Cost.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :amount => "9.99",
      #   :creator_id => 1,
      #   :user_id => 2,
      #   :lab_id => 3,
      #   :grant_id => 4,
      #   :category_id => 5,
      #   :periodicity => 6,
      #   :state => "State"
      # )
      FactoryGirl.create(:cost),
      FactoryGirl.create(:cost)
    ])
  end

  it "renders a list of costs" do
    render
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # assert_select "tr>td", :text => 1.to_s, :count => 2
    # assert_select "tr>td", :text => 2.to_s, :count => 2
    # assert_select "tr>td", :text => 3.to_s, :count => 2
    # assert_select "tr>td", :text => 4.to_s, :count => 2
    # assert_select "tr>td", :text => 5.to_s, :count => 2
    # assert_select "tr>td", :text => 6.to_s, :count => 2
    # assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
