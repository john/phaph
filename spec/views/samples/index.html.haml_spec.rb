require 'rails_helper'

RSpec.describe "samples/index", :type => :view do
  before(:each) do
    assign(:samples, [
      # Sample.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :source => "Source",
      #   :creator_id => 1,
      #   :lab_id => 2,
      #   :grant_id => 3,
      #   :collection_location => "Collection Location",
      #   :collection_latitude => "9.99",
      #   :collection_longitude => "9.99",
      #   :collection_temp => "9.99"
      # ),
      # Sample.create!(
      #   :name => "Name",
      #   :description => "MyText",
      #   :source => "Source",
      #   :creator_id => 1,
      #   :lab_id => 2,
      #   :grant_id => 3,
      #   :collection_location => "Collection Location",
      #   :collection_latitude => "9.99",
      #   :collection_longitude => "9.99",
      #   :collection_temp => "9.99"
      # )
      FactoryGirl.create(:sample),
      FactoryGirl.create(:sample)
    ])
  end

  it "renders" do
    render
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # assert_select "tr>td", :text => "Source".to_s, :count => 2
    # assert_select "tr>td", :text => 1.to_s, :count => 2
    # assert_select "tr>td", :text => 2.to_s, :count => 2
    # assert_select "tr>td", :text => 3.to_s, :count => 2
    # assert_select "tr>td", :text => "Collection Location".to_s, :count => 2
    # assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
