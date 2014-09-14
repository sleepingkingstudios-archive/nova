# spec/controllers/admin/registrations_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::RegistrationsController, :type => :controller do
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end # before each

  describe 'GET #new' do
    def perform_action
      get :new
    end # method perform_action

    it 'redirects to root' do
      perform_action
      expect(response).to redirect_to(root_path)
    end # it
  end # describe

  describe 'POST #create' do
    def perform_action
      post :create, :user => attributes_for(:user)
    end # method perform_action

    it 'responds with 403' do
      perform_action
      expect(response.status).to be 403
      expect(response.body).to be_blank
    end # it

    it 'does not create a User' do
      expect { perform_action }.not_to change(User, :count)
    end # it
  end # describe
end # describe
