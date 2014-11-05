require 'rails_helper'

RSpec.describe "home/index", :type => :view do
  before(:each) do

  end

  describe "For logged-in users" do
    before(:each) do
      # assign(:activities, [
      #   FactoryGirl.create(:activity),
      #   FactoryGirl.create(:activity)
      # ])
      assign(:activities, [
      ])
      john = FactoryGirl.create(:user)
      view.stub(:current_user).and_return(john)
      view.stub(:signed_in?).and_return(true)
    end

    it "renders" do
      render
    end
  end

  describe "For logged-out users" do
    before(:each) do
      view.stub(:signed_in?).and_return(false)
      view.stub(:app_slogan).and_return('Donkey Balls!')
    end

    it "renders" do
      render
    end
  end

end
