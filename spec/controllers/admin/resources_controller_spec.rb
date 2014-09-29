# spec/controllers/admin/resources_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::ResourcesController, :type => :controller do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#edit' do
    expect_behavior 'requires authentication'

    def perform_action
      get :edit, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path to a directory', :path => :valid_directory do
      let(:resource) { directories.last }

      expect_behavior 'renders template', :edit

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'
    end # describe
  end # describe

  describe '#update' do
    let(:resource_name) { :resource }
    let(:attributes)    { {} }

    expect_behavior 'requires authentication'

    def perform_action
      patch :update, :directories => path, resource_name => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path to a directory', :path => :valid_directory do
      let(:resource_name) { :directory }
      let(:resource)      { directories.last }

      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :edit

        expect_behavior 'assigns directories'

        expect_behavior 'assigns the resource'

        it 'does not update the resource' do
          expect { perform_action }.not_to change { resource.reload.title }
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:directory) }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(dashboard_directory_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'updates the resource' do
          expect { perform_action }.to change { resource.reload.title }.to(attributes[:title])
        end # it
      end # describe
    end # describe
  end # describe
end # describe
