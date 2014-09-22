require 'rails_helper'

RSpec.describe "collections/show", :type => :view do
  before(:each) do
    @collection = FactoryGirl.create(:collection)
  end

  describe "For logged-in users" do
    before(:each) do
      # john = FactoryGirl.create(:user)
      view.stub(:current_user).and_return( @collection.user )
      view.stub(:signed_in?).and_return(true)
    end

    it "renders" do
      render
      expect(view).to render_template(:show)
      # expect(rendered).to render_with_layout('application')
    end

    it "displays the 'add doc' button" do
      render
      expect(rendered).to match /Created on/
      expect(rendered).to match /add doc/
    end
  end


  describe "For logged-out users" do
    before(:each) do
      view.stub(:signed_in?).and_return(false)
    end

    it "renders" do
      render
      expect(view).to render_template(:show)
    end

    it "does not display the 'add doc' button" do
      render
      expect(rendered).to match /Created on/
      expect(rendered).not_to match /add doc/
    end
  end

end
