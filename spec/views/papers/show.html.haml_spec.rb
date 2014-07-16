require 'rails_helper'

RSpec.describe "papers/show", :type => :view do
  before(:each) do
    @paper = assign(:paper, Paper.create!(
      :name => "Name",
      :description => "MyText",
      :source => "Source",
      :journal => "Journal",
      :principle_author => "Principle Author",
      :other_authors => "Other Authors",
      :rights => "Rights",
      :creator_id => 1,
      :lab_id => 2,
      :grant_id => 3,
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/Journal/)
    expect(rendered).to match(/Principle Author/)
    expect(rendered).to match(/Other Authors/)
    expect(rendered).to match(/Rights/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/State/)
  end
end
