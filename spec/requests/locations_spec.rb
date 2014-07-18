require 'rails_helper'

RSpec.describe "Locations", :type => :request do
  describe "GET /locations" do
    it "redirects when not logged in" do
      get locations_path
      expect(response.status).to be(302)
    end
  end
end
