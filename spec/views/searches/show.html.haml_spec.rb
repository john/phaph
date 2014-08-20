require 'rails_helper'

RSpec.describe "searches/show", :type => :view do
  before(:each) do
    @search = assign(:search, Search.create!(
      :user_id => 1,
      :term => "Term",
      :scope => "Scope"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Term/)
    expect(rendered).to match(/Scope/)
  end
end
