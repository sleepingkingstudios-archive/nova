# spec/helpers/routes/blog_post_routes_helper_spec.rb

require 'rails_helper'

RSpec.describe Routes::BlogPostRoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  include Spec::Contexts::Helpers::RoutesHelperContexts

  it { expect(RoutesHelper).to be < described_class }

  describe '#blog_post_path' do
    it { expect(instance).to respond_to(:blog_post_path).with(1).arguments }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.blog_post_path post).to be == "/#{slug}/#{post.slug}" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.blog_post_path post).to be == "/#{slugs.join '/'}/#{post.slug}" }
    end # describe
  end # describe

  describe '#create_blog_post_path' do
    it { expect(instance).to respond_to(:create_blog_post_path).with(1).arguments }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      it { expect(instance.create_blog_post_path feature).to be == "/#{slug}/posts" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      it { expect(instance.create_blog_post_path feature).to be == "/#{slugs.join '/'}/posts" }
    end # describe
  end # describe

  describe '#edit_blog_post_path' do
    it { expect(instance).to respond_to(:edit_blog_post_path).with(1).argument }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.edit_blog_post_path post).to be == "/#{slug}/#{post.slug}/edit" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.edit_blog_post_path post).to be == "/#{slugs.join '/'}/#{post.slug}/edit" }
    end # describe
  end # describe

  describe '#export_blog_post_path' do
    it { expect(instance).to respond_to(:export_blog_post_path).with(1).argument.and_keywords(:pretty) }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.export_blog_post_path post).to be == "/#{slug}/#{post.slug}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_blog_post_path post, :pretty => true).to be == "/#{slug}/#{post.slug}/export?pretty=true" }
      end # describe
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.export_blog_post_path post).to be == "/#{slugs.join '/'}/#{post.slug}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_blog_post_path post, :pretty => true).to be == "/#{slugs.join '/'}/#{post.slug}/export?pretty=true" }
      end # describe
    end # describe
  end # describe

  describe '#index_blog_posts_path' do
    it { expect(instance).to respond_to(:index_blog_posts_path).with(1).arguments }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      it { expect(instance.index_blog_posts_path feature).to be == "/#{slug}/posts" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      it { expect(instance.index_blog_posts_path feature).to be == "/#{slugs.join '/'}/posts" }
    end # describe
  end # describe

  describe '#new_blog_post_path' do
    it { expect(instance).to respond_to(:new_blog_post_path).with(1).arguments }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      it { expect(instance.new_blog_post_path feature).to be == "/#{slug}/posts/new" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      it { expect(instance.new_blog_post_path feature).to be == "/#{slugs.join '/'}/posts/new" }
    end # describe
  end # describe

  describe '#preview_blog_post_path' do
    it { expect(instance).to respond_to(:preview_blog_post_path).with(1).arguments }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      it { expect(instance.preview_blog_post_path feature).to be == "/#{slug}/posts/preview" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      it { expect(instance.preview_blog_post_path feature).to be == "/#{slugs.join '/'}/posts/preview" }
    end # describe
  end # describe

  describe '#publish_blog_post_path' do
    it { expect(instance).to respond_to(:publish_blog_post_path).with(1).argument }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.publish_blog_post_path post).to be == "/#{slug}/#{post.slug}/publish" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.publish_blog_post_path post).to be == "/#{slugs.join '/'}/#{post.slug}/publish" }
    end # describe
  end # describe

  describe '#unpublish_blog_post_path' do
    it { expect(instance).to respond_to(:unpublish_blog_post_path).with(1).argument }

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.unpublish_blog_post_path post).to be == "/#{slug}/#{post.slug}/unpublish" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      let(:post) { build(:blog_post, :blog => feature) }

      it { expect(instance.unpublish_blog_post_path post).to be == "/#{slugs.join '/'}/#{post.slug}/unpublish" }
    end # describe
  end # describe
end # describe
