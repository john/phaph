require 'rails_helper'

RSpec.describe "documents/show", :type => :view do
  

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
    @document = FactoryGirl.create(:document)
  end

  it "renders" do
    render
  end
end
