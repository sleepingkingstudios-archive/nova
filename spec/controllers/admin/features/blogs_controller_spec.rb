# spec/controllers/admin/features/blogs_controller_spec.rb 

require 'rails_helper'

RSpec.describe Admin::Features::BlogsController do
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
      get :new, params
    end # method perform_action

    let(:params) { { :directories => path } }

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new resource', Blog
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      expect_behavior 'renders template', :new

      expect_behavior 'assigns directories'

      expect_behavior 'assigns new resource', Blog
    end # describe
  end # describe

  describe '#create' do
    let(:attributes) { {} }

    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      post :create, :directories => path, :blog => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :new

        expect_behavior 'assigns new resource', Blog

        expect_behavior 'assigns directories'

        it 'does not create a blog' do
          expect { perform_action }.not_to change(Blog, :count)
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:blog) }

        it 'redirects to the page' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(blog_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new blog' do
          expect { perform_action }.to change(Blog, :count).by(1)
        end # it
      end # describe
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :new

        expect_behavior 'assigns new resource', Blog

        expect_behavior 'assigns directories'

        it 'does not create a blog' do
          expect { perform_action }.not_to change(Blog, :count)
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:blog).merge :content => attributes_for(:text_content).merge(:_type => 'text_content') }

        it 'redirects to the blog' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(blog_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new blog' do
          expect { perform_action }.to change(Blog, :count).by(1)

          expect(assigns(:resource).directory).to be == directories.last
        end # it
      end # describe
    end # describe
  end # describe
end # describe
