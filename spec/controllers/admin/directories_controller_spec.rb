# spec/controllers/admin/directories_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::DirectoriesController do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#dashboard' do
    expect_behavior 'requires authentication'

    def perform_action
      get :dashboard, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      expect_behavior 'renders template', :dashboard

      expect_behavior 'assigns directories'
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      expect_behavior 'renders template', :dashboard

      expect_behavior 'assigns directories'
    end # describe
  end # describe
end # describe
