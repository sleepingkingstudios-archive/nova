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

    wrap_context 'with an empty path' do
      expect_behavior 'renders template', :show

      expect_behavior 'assigns directories'
    end # describe

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path to a blog' do
      include_context 'with a valid path to a feature'

      let(:resource) { create(:blog, :directory => directories.last) }

      expect_behavior 'renders template', :show

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'
    end # describe

    describe 'with a valid path to a blog post' do
      include_context 'with a valid path to a feature'

      let(:blog)     { create(:blog, :directory => directories.last) }
      let(:resource) { create(:blog_post, :blog => blog, :content => build(:content)) }
      let(:path)     { segments.push(blog.slug, resource.slug).join('/') }

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'

      context 'with an unpublished blog post' do
        it 'redirects to the blog' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(blog_path(blog))

          expect(request.flash[:warning]).not_to be_blank
        end # it

        context 'as an authenticated user' do
          before(:each) { sign_in :user, user }

          expect_behavior 'renders template', :show
        end # context
      end # context

      context 'with a published blog post' do
        let(:resource) { create(:blog_post, :blog => blog, :published_at => 1.day.ago, :content => build(:content)) }

        expect_behavior 'renders template', :show
      end # context
    end # describe

    wrap_context 'with a valid path to a directory' do
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

    describe 'with a valid path to a page' do
      include_context 'with a valid path to a feature'

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

        context 'as an authenticated user' do
          before(:each) { sign_in :user, user }

          expect_behavior 'renders template', :show
        end # context
      end # context

      context 'with a published page' do
        before(:each) { resource.set(:published_at => 1.day.ago) }

        expect_behavior 'renders template', :show
      end # context
    end # describe
  end # describe
end # describe
