# spec/controllers/resources_controller_spec.rb

require 'rails_helper'

RSpec.describe ResourcesController, :type => :controller do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#show' do
    def perform_action
      get :show, :directories => path
    end # method perform_action

    describe 'with an empty path', :path => :empty do
      expect_behavior 'renders template', :show

      expect_behavior 'assigns directories'
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path to a blog', :path => :valid_feature do
      let(:resource) { create(:blog, :directory => directories.last) }

      expect_behavior 'renders template', :show

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'
    end # describe

    describe 'with a valid path to a blog post', :path => :valid_feature do
      let(:blog)     { create(:blog, :directory => directories.last) }
      let(:resource) { create(:blog_post, :blog => blog, :content => build(:content)) }
      let(:path)     { segments.push(blog.slug, resource.slug).join('/') }

      expect_behavior 'renders template', :show
    end # describe

    describe 'with a valid path to a directory', :path => :valid_directory do
      let(:resource) { directories.last }

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'

      context 'without an index page' do
        expect_behavior 'renders template', 'directories/show'
      end # context

      context 'with an unpublished index page' do
        before(:each) do
          create(:page, :directory => directories.last, :title => 'Index', :content => build(:content))
        end # before

        expect_behavior 'renders template', 'directories/show'

        context 'as an authenticated user' do
          before(:each) { sign_in :user, user }

          expect_behavior 'renders template', 'features/pages/show'
        end # context
      end # context

      context 'with a published index page' do
        before(:each) do
          create(:page, :directory => directories.last, :title => 'Index', :published_at => 1.day.ago, :content => build(:content))
        end # before

        expect_behavior 'renders template', 'features/pages/show'
      end # describe
    end # describe

    describe 'with a valid path to a page', :path => :valid_feature do
      let(:resource) { create(:page, :directory => directories.last, :content => build(:content)) }

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'

      context 'with an unpublished page' do
        it 'redirects to the parent directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(directory_path(directories.last))

          expect(request.flash[:warning]).not_to be_blank
        end # it
      end # context

      context 'with a published page' do
        before(:each) { resource.set(:published_at => 1.day.ago) }

        expect_behavior 'renders template', :show
      end # context
    end # describe
  end # describe
end # describe
