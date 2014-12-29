require "rails_helper"

RSpec.describe CollectiblesController, :type => :routing do
  describe "routing" do

    it "routes to #show with a slug" do
      expect(:get => "/collectibles/1/foo").to route_to("comments#index")
    end
    
  end
end