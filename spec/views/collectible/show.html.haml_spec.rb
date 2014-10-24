require 'rails_helper'

RSpec.describe "collectibles/show", :type => :view do
  

  # describe "For logged-in users" do
  #   before(:each) do
  #     view.stub(:signed_in?).and_return(true)
  #   end

  # end

  # describe "For logged-out users" do
  #   before(:each) do
  #     view.stub(:signed_in?).and_return(true)
  #   end

  # end

  before(:each) do
    john = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(john)
    view.stub(:signed_in?).and_return(true)
    view.stub(:atomic_unit).and_return('blarg')
    @document = FactoryGirl.create(:document)
    @collection = FactoryGirl.create(:collection)
    @collectible = Collectible.create(user: john, document: @document, collection: @collection)
  end

  it "renders" do
    render
  end
end
