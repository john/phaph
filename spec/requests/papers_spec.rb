require 'rails_helper'

RSpec.describe "Papers", :type => :request do
  describe "GET /papers" do
    it "redirects when not logged in" do
      get papers_path
      expect(response.status).to be(302)
    end
  end
end
