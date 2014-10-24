require 'rails_helper'

RSpec.describe "documents/index", :type => :view do
  before(:each) do
  	view.stub(:atomic_unit).and_return('blarg')
    assign(:documents, [
      FactoryGirl.create(:document),
      FactoryGirl.create(:document)
    ])
  end

  it "renders" do
    render
  end
end
