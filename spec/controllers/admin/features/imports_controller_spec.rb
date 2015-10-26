# spec/controllers/admin/features/imports_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::Features::ImportsController do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#new' do
    expect_behavior 'requires authentication'

    def perform_action
      get :new, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :"features/imports/new"

      expect_behavior 'assigns directories'
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      expect_behavior 'renders template', :"features/imports/new"

      expect_behavior 'assigns directories'
    end # describe
  end # describe
end # describe
