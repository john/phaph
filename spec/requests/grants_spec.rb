require 'rails_helper'

RSpec.describe "Grants", :type => :request do
  describe "GET /grants" do
    it "redirects when not logged in" do
      get grants_path
      expect(response.status).to be(302)
    end
  end
end
