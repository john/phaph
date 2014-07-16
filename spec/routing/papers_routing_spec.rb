require "rails_helper"

RSpec.describe PapersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/papers").to route_to("papers#index")
    end

    it "routes to #new" do
      expect(:get => "/papers/new").to route_to("papers#new")
    end

    it "routes to #show" do
      expect(:get => "/papers/1").to route_to("papers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/papers/1/edit").to route_to("papers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/papers").to route_to("papers#create")
    end

    it "routes to #update" do
      expect(:put => "/papers/1").to route_to("papers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/papers/1").to route_to("papers#destroy", :id => "1")
    end

  end
end
