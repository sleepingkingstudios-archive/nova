# spec/controllers/admin/features/pages_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::Features::PagesController do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#index' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :index, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      expect_behavior 'renders template', :index

      expect_behavior 'assigns directories'
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
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

    describe 'with an empty path', :path => :empty do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new resource', Page

      expect_behavior 'assigns new content'
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new resource', Page

      expect_behavior 'assigns new content'
    end # describe
  end # describe
end # describe
