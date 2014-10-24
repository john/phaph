require 'rails_helper'

RSpec.describe "documents/new", :type => :view do

  describe "For logged-in users" do
    before(:each) do
      john = FactoryGirl.create(:user)
      view.stub(:atomic_unit).and_return('blarg')
      view.stub(:current_user).and_return(john)
      @document = Document.new
    end

    it "renders" do
      render
      expect(view).to render_template(:new)
    end
  end

end
