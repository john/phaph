require 'rails_helper'

RSpec.describe DocumentsController, :type => :controller do

	context "logged-in users" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET show" do
      
      it "assigns the requested document as @document" do
        # document = FactoryGirl.create(:document, user_id: @user.id)
        # document.user_id = @user.id
        # document.save # to defeat the before create filter in the factory
        
        # get :show, {:id => document.id}
        
        # expect(assigns(:document)).to eq(document)
        # expect(response).to have_http_status(:ok)
      end
      
    end

  end

end
