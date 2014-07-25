require "rails_helper"

RSpec.describe AuthenticationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/authentications").to route_to("authentications#index")
    end

    it "routes to #new" do
      expect(:get => "/authentications/new").to route_to("authentications#new")
    end

    it "routes to #show" do
      expect(:get => "/authentications/1").to route_to("authentications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/authentications/1/edit").to route_to("authentications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/authentications").to route_to("authentications#create")
    end

    it "routes to #update" do
      expect(:put => "/authentications/1").to route_to("authentications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/authentications/1").to route_to("authentications#destroy", :id => "1")
    end

  end
end
