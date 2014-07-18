require 'rails_helper'

RSpec.describe "categories/show", :type => :view do
  before(:each) do
    # @category = assign(:category, Category.create!(
    #   :name => "Name",
    #   :description => "MyText",
    #   :creator_id => 1,
    #   :lab_id => 2,
    #   :grant_id => 3,
    #   :state => "State"
    # ))
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    @category = FactoryGirl.create(:category)
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(/Name/)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(/1/)
    # expect(rendered).to match(/2/)
    # expect(rendered).to match(/3/)
    # expect(rendered).to match(/State/)
  end
end
