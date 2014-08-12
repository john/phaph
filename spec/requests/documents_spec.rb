require 'rails_helper'

RSpec.describe "Documents", :type => :request do
  describe "GET /documents" do
    it "redirects when not logged in" do
      get documents_path
      expect(response.status).to be(302)
    end
  end
end
