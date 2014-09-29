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
end # describe
