require 'rails_helper'

RSpec.describe "documents/index", :type => :view do
  before(:each) do
    assign(:documents, [
      FactoryGirl.create(:document),
      FactoryGirl.create(:document)
    ])
  end

  it "renders" do
    render
  end
end
