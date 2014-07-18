require 'rails_helper'

RSpec.describe "samples/show", :type => :view do
  before(:each) do
    @sample = FactoryGirl.create(:sample)
  end

  it "renders" do
    render
    # expect(rendered).to match(/Name/)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(/Source/)
    # expect(rendered).to match(/1/)
    # expect(rendered).to match(/2/)
    # expect(rendered).to match(/3/)
    # expect(rendered).to match(/Collection Location/)
    # expect(rendered).to match(/9.99/)
    # expect(rendered).to match(/9.99/)
    # expect(rendered).to match(/9.99/)
  end
end
