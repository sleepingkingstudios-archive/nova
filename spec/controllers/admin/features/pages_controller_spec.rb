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
      get :new, params
    end # method perform_action

    let(:params) { { :directories => path } }

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new resource', Page

      expect_behavior 'assigns new content'

      describe 'with content_type => text' do
        let(:params) { super().merge :content_type => 'TextContent' }

        expect_behavior 'assigns new content', TextContent
      end # describe
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a directory' do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new resource', Page

      expect_behavior 'assigns new content'

      describe 'with content_type => text' do
        let(:params) { super().merge :content_type => 'TextContent' }

        expect_behavior 'assigns new content', TextContent
      end # describe
    end # describe
  end # describe

  describe '#preview' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      post :preview, params
    end # method perform_action

    let(:params) { { :directories => path } }

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :show

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new resource', Page

      expect_behavior 'assigns new content'

      describe 'with content_type => text' do
        let(:params) { super().merge :content_type => 'TextContent' }

        expect_behavior 'assigns new content', TextContent
      end # describe
    end # describe
  end # describe

  describe '#create' do
    let(:attributes) { {} }

    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      post :create, :directories => path, :page => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an empty path' do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :new

        expect_behavior 'assigns new resource', Page

        expect_behavior 'assigns directories'

        it 'does not create a page' do
          expect { perform_action }.not_to change(Page, :count)
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:page).merge :content => attributes_for(:text_content).merge(:_type => 'text_content') }

        it 'redirects to the page' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(page_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new page' do
          expect { perform_action }.to change(Page, :count).by(1)
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

        expect_behavior 'assigns new resource', Page

        expect_behavior 'assigns directories'

        it 'does not create a page' do
          expect { perform_action }.not_to change(Page, :count)
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:page).merge :content => attributes_for(:text_content).merge(:_type => 'text_content') }

        it 'redirects to the page' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(page_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new page' do
          expect { perform_action }.to change(Page, :count).by(1)

          expect(assigns(:resource).directory).to be == directories.last
        end # it
      end # describe
    end # describe
  end # describe
end # describe
