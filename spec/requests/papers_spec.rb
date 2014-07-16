require 'rails_helper'

RSpec.describe "Papers", :type => :request do
  describe "GET /papers" do
    it "works! (now write some real specs)" do
      get papers_path
      expect(response.status).to be(200)
    end
  end
end
