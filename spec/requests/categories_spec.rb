require 'rails_helper'

RSpec.describe "Categories", :type => :request do
  describe "GET /categories" do
    it "redirects when not logged in" do
      get categories_path
      expect(response.status).to be(302)
    end
  end
end
