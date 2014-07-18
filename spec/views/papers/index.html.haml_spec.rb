require 'rails_helper'

RSpec.describe "papers/index", :type => :view do
  before(:each) do
    assign(:papers, [
      # Paper.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :source => "Source",
      #   :journal => "Journal",
      #   :principle_author => "Principle Author",
      #   :other_authors => "Other Authors",
      #   :rights => "Rights",
      #   :creator_id => 1,
      #   :lab_id => 2,
      #   :grant_id => 3,
      #   :state => "State"
      # ),
      # Paper.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :source => "Source",
      #   :journal => "Journal",
      #   :principle_author => "Principle Author",
      #   :other_authors => "Other Authors",
      #   :rights => "Rights",
      #   :creator_id => 1,
      #   :lab_id => 2,
      #   :grant_id => 3,
      #   :state => "State"
      # )
      FactoryGirl.create(:paper),
      FactoryGirl.create(:paper)
    ])
  end

  it "renders a list of papers" do
    render
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => "Source".to_s, :count => 2
    # assert_select "tr>td", :text => "Journal".to_s, :count => 2
    # assert_select "tr>td", :text => "Principle Author".to_s, :count => 2
    # assert_select "tr>td", :text => "Other Authors".to_s, :count => 2
    # assert_select "tr>td", :text => "Rights".to_s, :count => 2
    # assert_select "tr>td", :text => 1.to_s, :count => 2
    # assert_select "tr>td", :text => 2.to_s, :count => 2
    # assert_select "tr>td", :text => 3.to_s, :count => 2
    # assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
