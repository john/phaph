require 'rails_helper'

RSpec.describe "collections/index", :type => :view do
  before(:each) do
    assign(:collections, [
      FactoryGirl.create(:collection),
      FactoryGirl.create(:collection)
    ])
  end

  it "renders" do
    render
  end
end
