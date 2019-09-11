require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#destroy action" do

    it "shouldn't allow users who didn't create the gram to destroy it" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user

      delete :destroy, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unantheuticated users to destroy gram" do 
      gram = FactoryBot.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully destroy a gram" do 
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "should return 404 error if gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do 

    it "should not let users who did not create the gram update it" do 
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user

      patch :update, params: { id: gram.id, gram: { message: "wahoo" } }
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unauthenticated users update a gram" do 
      gram = FactoryBot.create(:gram)
      patch :update, params: { id: gram.id, gram: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully update a gram" do
      gram = FactoryBot.create(:gram, message: "Initial Value")
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: 'changed' } }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user

      gram = FactoryBot.create(:gram)
      patch :update, params: { id: 'TACOCAT', gram: { message: 'changed'} }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unproccessable entity" do
      gram = FactoryBot.create(:gram, message: 'Initial Value')
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq 'Initial Value'
    end
  end

  describe "grams#edit action" do

    it "should not let a user who did not create the gram to edit a gram" do 
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user

      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unauthorized users acces an edit form for a gram" do
      gram = FactoryBot.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully load the edit form if the gram is found" do
      user = FactoryBot.create(:user)
      sign_in user

      gram = FactoryBot.create(:gram)
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return error 404 message if the gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user

      gram = FactoryBot.create(:gram)
      get :edit, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index action"  do 
    it "should succesfully show the page" do 
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "gram#new action" do

    it "should require users to be logged in" do
      get :new 
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "gram#create action" do

    it "should require users to be logged in" do 
      post :create, params: {grams: { message: "Hello!" } }
      expect(response).to redirect_to new_user_session_path
    
    end

    it "should succesfully create a new gram in our datatbase" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end 

  describe "grams#show should action" do
    it "it should succesfully load the page if the gram is found" do 
      gram = FactoryBot.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return 404 error if the gram is not found" do
      gram = FactoryBot.create(:gram)
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

end
