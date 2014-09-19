require 'rails_helper'

RSpec.describe "searches/show", :type => :view do
  before(:each) do
    @search = assign(:search, Search.create!(
      :user_id => 1,
      :term => "Term",
      :scope => "Scope"
    ))
  end

  it "renders" do
    render
  end
end
