require 'rails_helper'

RSpec.describe DocumentsController, :type => :controller do
  
  let(:valid_attributes) {
    {name: 'phu'}
  }
  
  let(:invalid_attributes) {
    {name: ''}
  }
  
  context "logged-in users" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
    
    describe "GET index" do
      
      it "assigns the user's documents as @documents" do
        document = FactoryGirl.create(:document)
        document.user_id = @user.id
        document.save # to defeat the before create filter in the factory
        
        get :index
        
        expect(response).to have_http_status(:ok)
        expect(assigns(:resources)).to match_array([document])
      end
    
    end
    
    # describe "GET imports" do
    #   it "assigns importable documents as @documents" do
    #     document = FactoryGirl.create(:document)
    #     get :imports
    #     expect(assigns(:documents)).to eq([document])
    #   end
    # end

    describe "GET show" do
      
      it "assigns the requested document as @document" do
        document = FactoryGirl.create(:document, user_id: @user.id)
        document.user_id = @user.id
        document.save # to defeat the before create filter in the factory
        
        get :show, {:id => document.to_param}
        
        expect(assigns(:document)).to eq(document)
        expect(response).to have_http_status(:ok)
      end
      
      it "only lets you see your own docs" do
        
      end
      
    end

    describe "GET new" do
      it "assigns a new document as @document" do
        get :new
        
        # expect(assigns(:document)).to be_a_new(document)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET edit" do
      it "assigns the requested document as @document" do
        document = FactoryGirl.create(:document, user_id: @user.id)
        get :edit, {:id => document.to_param}
        expect(assigns(:document)).to eq(document)
      end
    end

    # describe "POST create" do
    #   describe "with valid params" do
    #     # it "creates a new document" do
    #     #   expect {
    #     #     post :create, {:document => valid_attributes}
    #     #   }.to change(document, :count).by(1)
    #     # end
    #
    #     it "assigns a newly created document as @document" do
    #       post :create, {:document => valid_attributes}
    #       expect(assigns(:document)).to be_a(document)
    #       expect(assigns(:document)).to be_persisted
    #     end
    #
    #     it "redirects to the created document" do
    #       post :create, {:document => valid_attributes}
    #       expect(response).to redirect_to(document.last)
    #     end
    #   end
    #
    #   describe "with invalid params" do
    #     it "assigns a newly created but unsaved document as @document" do
    #       post :create, {:document => invalid_attributes}
    #       expect(assigns(:document)).to be_a_new(document)
    #     end
    #
    #     it "re-renders the 'new' template" do
    #       post :create, {:document => invalid_attributes}
    #       expect(response).to render_template("new")
    #     end
    #   end
    # end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          {name: 'foo'}
        }

        it "updates the requested document" do
          document = FactoryGirl.create(:document, user_id: @user.id)
          put :update, {:id => document.to_param, :document => new_attributes}
          document.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested document as @document" do
          document = FactoryGirl.create(:document, user_id: @user.id)
          put :update, {:id => document.to_param, :document => valid_attributes}
          expect(assigns(:document)).to eq(document)
        end

        # it "redirects to the document" do
        #   document = FactoryGirl.create(:document, user_id: @user.id)
        #   put :update, {:id => document.to_param, :document => valid_attributes}
        #   expect(response).to redirect_to(document)
        # end
      end

      # describe "with invalid params" do
      #   it "assigns the document as @document" do
      #     document = FactoryGirl.create(:document, name: '')
      #     put :update, {:id => document.to_param, :document => invalid_attributes}
      #     expect(assigns(:document)).to eq(document)
      #   end
      #
      #   it "re-renders the 'edit' template" do
      #     document = FactoryGirl.create(:document)
      #     put :update, {:id => document.to_param, :document => invalid_attributes}
      #     expect(response).to render_template("edit")
      #   end
      # end
    end

    # describe "DELETE destroy" do
    #   it "destroys the requested document" do
    #     document = FactoryGirl.create(:document)
    #     expect {
    #       delete :destroy, {:id => document.to_param}
    #     }.to change(document, :count).by(-1)
    #   end
    #
    #   it "redirects to the documents list" do
    #     document = FactoryGirl.create(:document)
    #     delete :destroy, {:id => document.to_param}
    #     expect(response).to redirect_to(documents_url)
    #   end
    # end
    
  end
  
  
  
  
  context "logged-out users" do

    describe "GET index" do

      it "blocks unauthenticated access" do
        get :index
        # response.should redirect_to(new_user_session_path)
        expect(response).to have_http_status(:found)
      end

    end

  end

end
