require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action"  do 
    it "should succesfully show the page" do 
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "gram#new action" do
    it "should succesfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "gram#create action" do
    it "should succesfully create a new gram in our datatbase" do
      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
    end
  end 
end
