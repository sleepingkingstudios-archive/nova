# spec/controllers/directories_controller_spec.rb

require 'rails_helper'

RSpec.describe DirectoriesController, :type => :controller do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#show' do
    def perform_action
      get :show, :directories => path
    end # method perform_action

    describe 'with an empty path', :path => :empty do
      it 'renders the show template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:show)
      end # it

      expect_behavior 'assigns directories'
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      it 'renders the show template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:show)
      end # it

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#update' do
    let(:attributes) { {} }

    expect_behavior 'requires authentication', :authenticate_root => false

    def perform_action
      patch :update, :directories => path, :directory => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        it 'renders the edit template' do
          perform_action

          expect(response.status).to be == 200
          expect(response).to render_template(:edit)
        end # it

        it 'does not update the directory' do
          expect { perform_action }.not_to change { Directory.last.reload.title }
        end # it

        expect_behavior 'assigns directories'
      end # describe

      describe 'with valid params' do
        let(:title)      { attributes_for(:directory).fetch(:title) }
        let(:attributes) { { :title => title } }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(index_directory_path(assigns :current_directory))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'updates the directory' do
          expect { perform_action }.to change { Directory.last.reload.title }.to(title)
        end # it
      end # describe
    end # describe
  end # describe

  describe '#destroy' do
    expect_behavior 'requires authentication', :authenticate_root => false

    def perform_action
      delete :destroy, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      it 'redirects to the directory' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(index_directory_path(assigns(:directories)[-2]))

        expect(request.flash[:danger]).not_to be_blank
      end # it

      it 'destroys the directory' do
        expect { perform_action }.to change(Directory, :count).by(-1)
      end # it

      describe 'with a child directory' do
        before(:each) { create(:directory, :parent => directories.last) }

        it 'destroys the directory and child' do
          expect { perform_action }.to change(Directory, :count).by(-2)
        end # it
      end # describe

      describe 'with a feature' do
        before(:each) { create(:feature, :directory => directories.last) }

        it 'destroys the feature' do
          expect { perform_action }.to change(Feature, :count).by(-1)
        end # it
      end # describe
    end # describe
  end # describe
end # describe
