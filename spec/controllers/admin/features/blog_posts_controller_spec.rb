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
end # describe
