require 'rails_helper'

RSpec.describe "Samples", :type => :request do
  describe "GET /samples" do
    it "redirects when not logged in" do
      get samples_path
      expect(response.status).to be(302)
    end
  end
end
