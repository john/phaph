require 'rails_helper'

RSpec.describe "samples/show", :type => :view do
  before(:each) do
    @sample = assign(:sample, Sample.create!(
      :name => "Name",
      :description => "MyText",
      :source => "Source",
      :creator_id => 1,
      :lab_id => 2,
      :grant_id => 3,
      :collection_location => "Collection Location",
      :collection_latitude => "9.99",
      :collection_longitude => "9.99",
      :collection_temp => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Collection Location/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
