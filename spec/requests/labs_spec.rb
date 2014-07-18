require 'rails_helper'

RSpec.describe "Labs", :type => :request do
  describe "GET /labs" do
    it "redirects when not logged in" do
      get labs_path
      expect(response.status).to be(302)
    end
  end
end
