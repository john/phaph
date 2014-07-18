require 'rails_helper'

RSpec.describe "grants/index", :type => :view do
  before(:each) do
    assign(:grants, [
      # Grant.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :source => "Source",
      #   :amount => "9.99",
      #   :overhead => 1.5,
      #   :user_id => 1,
      #   :lab_id => 2,
      #   :state => "State"
      # ),
      # Grant.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :source => "Source",
      #   :amount => "9.99",
      #   :overhead => 1.5,
      #   :user_id => 1,
      #   :lab_id => 2,
      #   :state => "State"
      # )
      FactoryGirl.create(:grant),
      FactoryGirl.create(:grant)
    ])
  end

  it "renders a list of grants" do
    render
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => "Source".to_s, :count => 2
    # assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # assert_select "tr>td", :text => 1.to_s, :count => 2
    # assert_select "tr>td", :text => 2.to_s, :count => 2
    # assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
