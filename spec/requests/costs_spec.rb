require 'rails_helper'

RSpec.describe "Costs", :type => :request do
  describe "GET /costs" do
    it "redirects when not logged in" do
      get costs_path
      expect(response.status).to be(302)
    end
  end
end
