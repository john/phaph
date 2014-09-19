require 'rails_helper'

RSpec.describe HomeController, :type => :controller do

  # context "logged-out users" do
    
  #   # before(:each) do
  #   #   sign_in nil
  #   # end
    
  #   describe "GET index" do
      
  #     it "doesn't assign documents" do
  #       FactoryGirl.create(:document)
  #       get :index
        
  #       expect(response).to have_http_status(:ok)
  #       expect(assigns(:documents)).to be_nil
  #     end
      
  #     it "doesn't assign collections" do
  #       FactoryGirl.create(:collection)
  #       get :index
        
  #       expect(response).to have_http_status(:ok)
  #       expect(assigns(:collections)).to be_nil
  #     end
      
  #   end
    
  # end
  
  context "logged-in users" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
    
    describe "GET index" do
      
      it "assigns @documents" do
        document = FactoryGirl.create(:document)
        get :index
        
        expect(response).to have_http_status(:ok)
        expect(assigns(:documents)).to match_array([document])
      end
      
      it "assigns @collections" do
        collection = FactoryGirl.create(:collection)
        get :index
        
        expect(response).to have_http_status(:ok)
        expect(assigns(:collections)).to match_array([collection])
      end
    
    end
    
  end
  
end
