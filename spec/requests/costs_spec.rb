require 'rails_helper'

RSpec.describe "Costs", :type => :request do
  describe "GET /costs" do
    it "works! (now write some real specs)" do
      get costs_path
      expect(response.status).to be(200)
    end
  end
end
