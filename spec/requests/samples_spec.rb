require 'rails_helper'

RSpec.describe "Samples", :type => :request do
  describe "GET /samples" do
    it "works! (now write some real specs)" do
      get samples_path
      expect(response.status).to be(200)
    end
  end
end
