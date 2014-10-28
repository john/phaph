require 'rails_helper'

RSpec.describe CollectiblesController, :type => :controller do

	context "logged-in users" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET show" do
      it "assigns the requested collectible as @collectible" do
        collectible = FactoryGirl.create(:collectible)
        get :show, {:id => collectible.id}
        expect(assigns(:collectible)).to eq(collectible)
        expect(response).to have_http_status(:ok)
      end
    end
    
    describe "xhr GET" do
      before(:each) do
        @collectible = FactoryGirl.create(:collectible)
        sign_in @user
      end
      
      it "follows @collectible" do
        xhr :get, :follow, {:id => @collectible.id, :format => :js}
        expect(assigns(:collectible)).to eq(@collectible)
        expect(@user.follows?(@collectible)).to be true
        expect(response).to have_http_status(:ok)
      end
      
      it "unfollows @collectible" do
        xhr :get, :follow, {:id => @collectible.id, :format => :js}
        expect(@user.follows?(@collectible)).to be true
        
        xhr :get, :unfollow, {:id => @collectible.id, :format => :js}
        expect(assigns(:collectible)).to eq(@collectible)
        expect(@user.follows?(@collectible)).to be false
        expect(response).to have_http_status(:ok)
      end
      
      it "likes @collectible" do
        xhr :get, :like, {:id => @collectible.id, :format => :js}
        expect(assigns(:collectible)).to eq(@collectible)
        expect(@user.likes?(@collectible)).to be true
        expect(response).to have_http_status(:ok)
      end
      
      it "unlikes @collectible" do
        xhr :get, :like, {:id => @collectible.id, :format => :js}
        expect(@user.likes?(@collectible)).to be true
        
        xhr :get, :unlike, {:id => @collectible.id, :format => :js}
        expect(@user.likes?(@collectible)).to be false
        expect(response).to have_http_status(:ok)
      end
    end
  end

end
