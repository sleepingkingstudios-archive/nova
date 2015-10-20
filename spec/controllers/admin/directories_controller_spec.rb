# spec/controllers/admin/directories_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::DirectoriesController do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#dashboard' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :dashboard, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :dashboard

      expect_behavior 'assigns directories'
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      expect_behavior 'renders template', :dashboard

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#index' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :index, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :index

      expect_behavior 'assigns directories'
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      expect_behavior 'renders template', :index

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#new' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :new, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new directory'
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new directory'
    end # describe
  end # describe

  describe '#create' do
    let(:attributes) { {} }

    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      post :create, :directories => path, :directory => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :new

        expect_behavior 'assigns new directory'

        expect_behavior 'assigns directories'

        it 'does not create a directory' do
          expect { perform_action }.not_to change(Directory, :count)
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:directory) }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(dashboard_directory_path(assigns :directory))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new directory' do
          expect { perform_action }.to change(Directory, :count).by(1)
        end # it
      end # describe
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :new

        expect_behavior 'assigns new directory'

        expect_behavior 'assigns directories'

        it 'does not create a directory' do
          expect { perform_action }.not_to change(Directory, :count)
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:directory) }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(dashboard_directory_path(assigns :directory))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new directory' do
          expect { perform_action }.to change(Directory, :count).by(1)

          expect(assigns(:directory).ancestors).to be == directories
        end # it
      end # describe
    end # describe
  end # describe

  describe '#import_directory' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :import_directory, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :"directories/import"

      expect_behavior 'assigns directories'
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      expect_behavior 'renders template', :"directories/import"

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#import_feature' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :import_feature, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :"features/import"

      expect_behavior 'assigns directories'
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      expect_behavior 'renders template', :"features/import"

      expect_behavior 'assigns directories'
    end # describe
  end # describe
end # describe
