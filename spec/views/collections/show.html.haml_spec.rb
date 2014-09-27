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

    describe "for a doc you own" do
      it "renders" do
        render
        expect(view).to render_template(:show)
        # expect(view).to render_with_layout('application')
      end

      it "displays the 'add doc' button" do
        render
        expect(rendered).to match /Created on/
        expect(rendered).to match /add doc/
      end
    end

    describe "for a non-public collection you don't own" do
      # you can see the 'follow' button
      # you can't see the 'add doc' button
    end

    describe "for a public collection you don't own" do
      # you can see the 'follow' button
      # you can see the 'add doc' button
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
