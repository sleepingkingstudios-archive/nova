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
end # describe
