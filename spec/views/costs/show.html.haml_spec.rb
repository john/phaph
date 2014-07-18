require 'rails_helper'

RSpec.describe "costs/show", :type => :view do
  before(:each) do
    # @cost = assign(:cost, Cost.create!(
    #   :name => "Name",
    #   :description => "MyText",
    #   :amount => "9.99",
    #   :creator_id => 1,
    #   :user_id => 2,
    #   :lab_id => 3,
    #   :grant_id => 4,
    #   :category_id => 5,
    #   :periodicity => 6,
    #   :state => "State"
    # ))
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @cost = FactoryGirl.create(:cost)
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(/Name/)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(/9.99/)
    # expect(rendered).to match(/1/)
    # expect(rendered).to match(/2/)
    # expect(rendered).to match(/3/)
    # expect(rendered).to match(/4/)
    # expect(rendered).to match(/5/)
    # expect(rendered).to match(/6/)
    # expect(rendered).to match(/State/)
  end
end
