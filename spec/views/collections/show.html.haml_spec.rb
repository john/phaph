require 'rails_helper'

RSpec.describe "collections/show", :type => :view do
  before(:each) do
    @collection = assign(:collection, Collection.create!(
      :name => "Name",
      :description => "MyText",
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/State/)
  end
end
