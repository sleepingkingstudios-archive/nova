# spec/controllers/admin/features/blog_posts_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::Features::BlogPostsController do
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:directories) { [] }
  let(:blog)        { double('blog', :slug => 'nope') }
  let(:user)        { create(:user) }

  shared_examples 'assigns blog' do
    it 'assigns the blog to @blog' do
      perform_action

      expect(assigns :blog).to be == blog
    end # it
  end # shared_examples

  describe '#index' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :index, :blog => blog.slug, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      expect_behavior 'assigns directories'

      describe 'with an invalid blog' do
        expect_behavior 'redirects to the last found directory dashboard'
      end # describe

      describe 'with a valid blog' do
        let(:blog) { create(:blog, :directory => directories.last) }

        expect_behavior 'renders template', :index

        expect_behavior 'assigns blog'
      end # describe
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      expect_behavior 'assigns directories'

      describe 'with an invalid blog' do
        expect_behavior 'redirects to the last found directory dashboard'
      end # describe

      describe 'with a valid blog' do
        let(:blog) { create(:blog, :directory => directories.last) }

        expect_behavior 'renders template', :index

        expect_behavior 'assigns blog'
      end # describe
    end # describe
  end # describe

  describe '#new' do
    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      get :new, params
    end # method perform_action

    let(:params) { { :blog => blog.slug, :directories => path } }

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      expect_behavior 'assigns directories'

      describe 'with an invalid blog' do
        expect_behavior 'redirects to the last found directory dashboard'
      end # describe

      describe 'with a valid blog' do
        let(:blog) { create(:blog, :directory => directories.last) }

        expect_behavior 'renders template', :new

        expect_behavior 'assigns new resource', BlogPost

        expect_behavior 'assigns new content'

        describe 'with content_type => text' do
          let(:params) { super().merge :content_type => 'TextContent' }

          expect_behavior 'assigns new content', TextContent
        end # describe
      end # describe
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      expect_behavior 'assigns directories'

      describe 'with an invalid blog' do
        expect_behavior 'redirects to the last found directory dashboard'
      end # describe

      describe 'with a valid blog' do
        let(:blog) { create(:blog, :directory => directories.last) }

        expect_behavior 'renders template', :new

        expect_behavior 'assigns new resource', BlogPost

        expect_behavior 'assigns new content'

        describe 'with content_type => text' do
          let(:params) { super().merge :content_type => 'TextContent' }

          expect_behavior 'assigns new content', TextContent
        end # describe
      end # describe
    end # describe
  end # describe

  describe '#create' do
    let(:attributes) { {} }

    expect_behavior 'requires authentication'

    expect_behavior 'requires authentication for root directory'

    def perform_action
      post :create, params
    end # method perform_action

    before(:each) { sign_in :user, user }

    let(:params) { { :blog => blog.slug, :directories => path, :post => attributes } }

    describe 'with an empty path', :path => :empty do
      describe 'with an invalid blog' do
        expect_behavior 'redirects to the last found directory dashboard'
      end # describe

      describe 'with a valid blog' do
        let(:blog) { create(:blog, :directory => directories.last) }

        describe 'with invalid params' do
          let(:attributes) { super().merge :title => nil }

          expect_behavior 'renders template', :new

          expect_behavior 'assigns new resource', BlogPost

          expect_behavior 'assigns directories'

          it 'does not create a blog post' do
            expect { perform_action }.not_to change(blog.posts, :count)
          end # it
        end # describe

        describe 'with valid params' do
          let(:attributes) { attributes_for(:blog_post).merge :content => attributes_for(:text_content).merge(:_type => 'text_content') }

          it 'redirects to the post' do
            perform_action

            expect(response.status).to be == 302
            expect(response).to redirect_to(blog_post_path(assigns :resource))

            expect(request.flash[:success]).not_to be_blank
          end # it

          it 'creates a new blog post' do
            expect { perform_action }.to change(blog.posts, :count).by(1)
          end # it
        end # describe
      end # describe
    end # describe

    describe 'with an invalid path', :path => :invalid_directory do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    describe 'with a valid path', :path => :valid_directory do
      describe 'with an invalid blog' do
        expect_behavior 'redirects to the last found directory dashboard'
      end # describe

      describe 'with a valid blog' do
        let(:blog) { create(:blog, :directory => directories.last) }

        describe 'with invalid params' do
          let(:attributes) { super().merge :title => nil }

          expect_behavior 'renders template', :new

          expect_behavior 'assigns new resource', BlogPost

          expect_behavior 'assigns directories'

          it 'does not create a blog post' do
            expect { perform_action }.not_to change(blog.posts, :count)
          end # it
        end # describe

        describe 'with valid params' do
          let(:attributes) { attributes_for(:blog_post).merge :content => attributes_for(:text_content).merge(:_type => 'text_content') }

          it 'redirects to the post' do
            perform_action

            expect(response.status).to be == 302
            expect(response).to redirect_to(blog_post_path(assigns :resource))

            expect(request.flash[:success]).not_to be_blank
          end # it

          it 'creates a new blog post' do
            expect { perform_action }.to change(blog.posts, :count).by(1)
          end # it
        end # describe
      end # describe
    end # describe
  end # describe
end # describe
