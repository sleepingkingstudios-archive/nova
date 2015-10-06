# spec/controllers/admin/resources_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::ResourcesController, :type => :controller do
  include Decorators::SerializersHelper

  include Spec::Contexts::SerializerContexts
  include Spec::Contexts::Controllers::ResourcesContexts

  include Spec::Examples::SerializerExamples
  include Spec::Examples::Controllers::ResourcesExamples
  include Spec::Examples::Controllers::RenderingExamples

  let(:user) { create(:user) }

  describe '#edit' do
    expect_behavior 'requires authentication'

    def perform_action
      get :edit, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a blog' do
      expect_behavior 'renders template', :edit

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'
    end # describe

    wrap_context 'with a valid path to a blog post' do
      expect_behavior 'renders template', :edit

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'
    end # describe

    wrap_context 'with a valid path to a directory' do
      let(:resource) { directories.last }

      expect_behavior 'renders template', :edit

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'
    end # describe

    wrap_context 'with a valid path to a page' do
      expect_behavior 'renders template', :edit

      expect_behavior 'assigns directories'

      expect_behavior 'assigns the resource'
    end # describe
  end # describe

  describe '#update' do
    let(:resource_name) { :resource }
    let(:attributes)    { {} }

    expect_behavior 'requires authentication'

    def perform_action
      patch :update, :directories => path, resource_name => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a blog' do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :edit

        expect_behavior 'assigns directories'

        expect_behavior 'assigns the resource'

        it 'does not update the resource' do
          expect { perform_action }.not_to change { resource.reload.title }
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:blog) }

        it 'redirects to the blog' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(blog_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'updates the resource' do
          expect { perform_action }.to change { resource.reload.title }.to(attributes[:title])
        end # it
      end # describe
    end # describe

    wrap_context 'with a valid path to a blog post' do
      include_context 'with a valid path to a feature'

      let(:resource_name) { :post }
      let(:blog)          { create(:blog, :directory => directories.last) }
      let(:resource)      { create(:blog_post, :blog => blog, :content => build(:content)) }
      let(:path)          { segments.push(blog.slug, resource.slug).join('/') }

      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :edit

        expect_behavior 'assigns directories'

        expect_behavior 'assigns the resource'

        it 'does not update the resource' do
          expect { perform_action }.not_to change { resource.reload.title }
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:blog_post) }

        it 'redirects to the post' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(blog_post_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'updates the resource' do
          expect { perform_action }.to change { resource.reload.title }.to(attributes[:title])
        end # it
      end # describe
    end # describe

    wrap_context 'with a valid path to a directory' do
      let(:resource_name) { :directory }
      let(:resource)      { directories.last }

      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :edit

        expect_behavior 'assigns directories'

        expect_behavior 'assigns the resource'

        it 'does not update the resource' do
          expect { perform_action }.not_to change { resource.reload.title }
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:directory) }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(dashboard_directory_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'updates the resource' do
          expect { perform_action }.to change { resource.reload.title }.to(attributes[:title])
        end # it
      end # describe
    end # describe

    wrap_context 'with a valid path to a page' do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        expect_behavior 'renders template', :edit

        expect_behavior 'assigns directories'

        expect_behavior 'assigns the resource'

        it 'does not update the resource' do
          expect { perform_action }.not_to change { resource.reload.title }
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:page) }

        it 'redirects to the page' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(page_path(assigns :resource))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'updates the resource' do
          expect { perform_action }.to change { resource.reload.title }.to(attributes[:title])
        end # it
      end # describe
    end # describe
  end # describe

  describe '#destroy' do
    expect_behavior 'requires authentication'

    def perform_action
      delete :destroy, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a blog' do
      it 'redirects to the parent directory' do
        parent_directory = directories.last

        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(dashboard_directory_path(parent_directory))

        expect(request.flash[:danger]).not_to be_blank
      end # it

      it 'destroys the resource' do
        expect { perform_action }.to change(Blog, :count).by(-1)
      end # it
    end # describe

    wrap_context 'with a valid path to a blog post' do
      it 'redirects to the blog' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(blog_path(blog))

        expect(request.flash[:danger]).not_to be_blank
      end # it

      it 'destroys the resource' do
        expect { perform_action }.to change(blog.posts, :count).by(-1)
      end # it
    end # describe

    wrap_context 'with a valid path to a directory' do
      it 'redirects to the parent directory' do
        parent_directory = directories.last.parent

        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(dashboard_directory_path(parent_directory))

        expect(request.flash[:danger]).not_to be_blank
      end # it

      it 'destroys the resource' do
        expect { perform_action }.to change(Directory, :count).by(-1)
      end # it
    end # describe

    wrap_context 'with a valid path to a page' do
      it 'redirects to the parent directory' do
        parent_directory = directories.last

        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(dashboard_directory_path(parent_directory))

        expect(request.flash[:danger]).not_to be_blank
      end # it

      it 'destroys the resource' do
        expect { perform_action }.to change(Page, :count).by(-1)
      end # it
    end # describe
  end # describe

  describe '#publish' do
    expect_behavior 'requires authentication'

    def perform_action
      put :publish, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a blog' do
      it 'redirects to the resource' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(blog_path(resource))

        expect(request.flash[:warning]).not_to be_blank
      end # it
    end # describe

    wrap_context 'with a valid path to a blog post' do
      it 'redirects to the post' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(blog_post_path(resource))

        expect(request.flash[:success]).not_to be_blank
      end # it

      it 'publishes the post' do
        expect { perform_action }.to change { resource.reload.published_at }.to be_a ActiveSupport::TimeWithZone
      end # it
    end # describe

    wrap_context 'with a valid path to a directory' do
      it 'redirects to the directory' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(dashboard_directory_path(directories.last))

        expect(request.flash[:warning]).not_to be_blank
      end # it
    end # describe

    wrap_context 'with a valid path to a page' do
      it 'redirects to the page' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(page_path(resource))

        expect(request.flash[:success]).not_to be_blank
      end # it

      it 'publishes the page' do
        expect { perform_action }.to change { resource.reload.published_at }.to be_a ActiveSupport::TimeWithZone
      end # it
    end # describe
  end # describe

  describe '#unpublish' do
    expect_behavior 'requires authentication'

    def perform_action
      put :unpublish, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with a valid path to a blog' do
      it 'redirects to the resource' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(blog_path(resource))

        expect(request.flash[:warning]).not_to be_blank
      end # it
    end # describe

    wrap_context 'with a valid path to a blog post' do
      let!(:resource) { create(:blog_post, :blog => blog, :content => build(:content), :published_at => 1.day.ago) }

      it 'redirects to the post' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(blog_post_path(resource))

        expect(request.flash[:warning]).not_to be_blank
      end # it

      it 'unpublishes the post' do
        expect { perform_action }.to change { resource.reload.published_at }.to nil
      end # it

      it 'clears the published order cache' do
        expect { perform_action }.to change { resource.reload.published_order }.to nil
      end # it
    end # describe

    wrap_context 'with a valid path to a directory' do
      it 'redirects to the directory' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(dashboard_directory_path(directories.last))

        expect(request.flash[:warning]).not_to be_blank
      end # it
    end # describe

    wrap_context 'with a valid path to a page' do
      let!(:resource) { create(:page, :directory => directories.last, :content => build(:content), :published_at => 1.day.ago) }

      it 'redirects to the page' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(page_path(resource))

        expect(request.flash[:warning]).not_to be_blank
      end # it

      it 'unpublishes the page' do
        expect { perform_action }.to change { resource.reload.published_at }.to nil
      end # it
    end # describe
  end # describe

  describe '#export' do
    shared_examples 'should export the resource' do |proc|
      let(:json) { JSON.parse response.body }

      it 'should export the resource' do
        perform_action

        expect(response.status).to be == 200
        expect(response.body).not_to be_blank

        expect_to_serialize_attributes json, resource

        SleepingKingStudios::Tools::ObjectTools.apply self, proc if proc.respond_to?(:call)
      end # it
    end # shared_examples

    let(:blacklisted_attributes) { %w(_id _type directory_id) }

    expect_behavior 'requires authentication'

    def perform_action
      get :export, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    wrap_context 'with an invalid path' do
      expect_behavior 'redirects to the last found directory dashboard'
    end # describe

    wrap_context 'with the root path' do
      let(:blacklisted_attributes) { super() << 'directories' << 'features' << 'parent_id' }

      include_examples 'should export the resource', ->() {
        expect(json['directories']).to be_blank

        expect(json['features']).to be_blank
      } # end examples

      context 'with many features' do
        let(:pages) { Array.new(3) { create(:page, :content => build(:content), :directory => nil) } }

        before(:each) { pages.each { |page| resource.features << page } }

        include_examples 'should export the resource', ->() {
          expect(json['directories']).to be_blank

          expect_to_serialize_directory_features json, resource
        } # end examples
      end # context

      context 'with many descendant directories' do
        let(:children)      { Array.new(3) { create(:directory, :parent => nil) } }
        let(:grandchildren) { Array.new(3) { create(:directory, :parent => children.first) } }

        before(:each) do
          grandchildren.each { |directory| children.first.children << directory }
        end # before each

        include_examples 'should export the resource', ->() {
          expect_to_serialize_directory_children json, resource, :recursive => true, :relations => :all

          expect(json['features']).to be_blank
        } # end examples

        context 'with many features' do
          before(:each) do
            [resource, *children, *grandchildren].each do |directory|
              3.times { create(:page, :content => build(:content), :directory => directory) }
            end # each
          end # before each

          include_examples 'should export the resource', ->() {
            expect_to_serialize_directory_children json, resource, :recursive => true, :relations => :all

            expect_to_serialize_directory_features json, resource
          } # end examples
        end # context
      end # context
    end # wrap_context

    wrap_context 'with a valid path to a blog' do
      let(:blacklisted_attributes) { super() << 'posts' << 'blog_id' }

      include_examples 'should export the resource'

      context 'with many posts' do
        let(:posts) { Array.new(3) { create(:blog_post, :content => build(:content), :blog => resource) } }

        include_examples 'should export the resource', ->() {
          expect_to_serialize_blog_posts json, resource
        } # end examples
      end # context
    end # wrap_context

    wrap_context 'with a valid path to a blog post' do
      let(:blacklisted_attributes) { super() << 'blog_id' }

      include_examples 'should export the resource', ->() {
        content = json.fetch('content')

        expect(content).to be == serialize(resource.content)
      } # end examples
    end # wrap_context

    wrap_context 'with a valid path to a directory' do
      let(:blacklisted_attributes) { super() << 'directories' << 'features' << 'parent_id' }
      let(:resource)               { directories.last }

      include_examples 'should export the resource', ->() {
        expect(json['directories']).to be_blank

        expect(json['features']).to be_blank
      } # end examples

      context 'with many features' do
        let(:pages) { Array.new(3) { create(:page, :content => build(:content), :directory => resource) } }

        before(:each) { pages.each { |page| resource.features << page } }

        include_examples 'should export the resource', ->() {
          expect(json['directories']).to be_blank

          expect_to_serialize_directory_features json, resource
        } # end examples
      end # context

      context 'with many descendant directories' do
        let(:children)      { Array.new(3) { create(:directory, :parent => resource) } }
        let(:grandchildren) { Array.new(3) { create(:directory, :parent => children.first) } }

        before(:each) do
          resource.save!

          children.each { |directory| resource.children << directory }

          grandchildren.each { |directory| children.first.children << directory }
        end # before each

        include_examples 'should export the resource', ->() {
          expect_to_serialize_directory_children json, resource, :recursive => true, :relations => :all

          expect(json['features']).to be_blank
        } # end examples

        context 'with many features' do
          before(:each) do
            [resource, *children, *grandchildren].each do |directory|
              3.times { create(:page, :content => build(:content), :directory => directory) }
            end # each
          end # before each

          include_examples 'should export the resource', ->() {
            expect_to_serialize_directory_children json, resource, :recursive => true, :relations => :all

            expect_to_serialize_directory_features json, resource
          } # end examples
        end # context
      end # context
    end # wrap_context

    wrap_context 'with a valid path to a page' do
      include_examples 'should export the resource', ->() {
        content = json.fetch('content')

        expect(content).to be == serialize(resource.content)
      } # end examples
    end # wrap_context
  end # describe
end # describe
