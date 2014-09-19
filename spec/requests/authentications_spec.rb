require 'rails_helper'

RSpec.describe "Authentications", :type => :request do

  describe "GET /authentications" do
    it "redirects when logged-out" do
      get authentications_path
      expect(response.status).to be(302)
    end
  end

end
