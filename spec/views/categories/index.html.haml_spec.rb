require 'rails_helper'

RSpec.describe "categories/index", :type => :view do
  before(:each) do
    assign(:categories, [
      Category.create!(
        :name => "Name",
        :description => "MyText",
        :creator_id => 1,
        :lab_id => 2,
        :grant_id => 3,
        :state => "State"
      ),
      Category.create!(
        :name => "Name",
        :description => "MyText",
        :creator_id => 1,
        :lab_id => 2,
        :grant_id => 3,
        :state => "State"
      )
    ])
  end

  it "renders a list of categories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
