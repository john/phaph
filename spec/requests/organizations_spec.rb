require 'rails_helper'

RSpec.describe "Organizations", :type => :request do
  describe "GET /organizations" do
    it "redirects when not logged in" do
      get organizations_path
      expect(response.status).to be(302)
    end
  end
end
