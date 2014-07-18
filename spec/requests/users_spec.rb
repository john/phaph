require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /users" do
    it "redirects not logged in" do
      get users_path
      expect(response.status).to be(302)
    end
    
    # it "works logged in" do
    #   john = FactoryGirl.create(:user)
    #   view.stub(:current_user).and_return(john)
    #   get users_path
    #   expect(response.status).to be(200)
    # end
  end
end
