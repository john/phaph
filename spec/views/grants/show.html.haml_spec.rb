require 'rails_helper'

RSpec.describe "grants/show", :type => :view do
  before(:each) do
    # @grant = assign(:grant, Grant.create!(
    #   :name => "Name",
    #   :description => "MyText",
    #   :source => "Source",
    #   :amount => "9.99",
    #   :overhead => 1.5,
    #   :user_id => 1,
    #   :lab_id => 2,
    #   :state => "State"
    # ))
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @grant = FactoryGirl.create(:grant)
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(/Name/)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(/Source/)
    # expect(rendered).to match(/9.99/)
    # expect(rendered).to match(/1.5/)
    # expect(rendered).to match(/1/)
    # expect(rendered).to match(/2/)
    # expect(rendered).to match(/State/)
  end
end
