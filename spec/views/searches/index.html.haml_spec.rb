require 'rails_helper'

RSpec.describe "searches/index", :type => :view do
  before(:each) do
    assign(:searches, [
      Search.create!(
        :user_id => 1,
        :term => "Term",
        :scope => "Scope"
      ),
      Search.create!(
        :user_id => 1,
        :term => "Term",
        :scope => "Scope"
      )
    ])
  end

  it "renders a list of searches" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Term".to_s, :count => 2
    assert_select "tr>td", :text => "Scope".to_s, :count => 2
  end
end
