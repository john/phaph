require 'rails_helper'

RSpec.describe "Authentications", :type => :request do
  describe "GET /authentications" do
    it "works! (now write some real specs)" do
      get authentications_path
      expect(response.status).to be(200)
    end
  end
end
