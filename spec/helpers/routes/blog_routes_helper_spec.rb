# spec/helpers/routes/blog_routes_helper_spec.rb

require 'rails_helper'

RSpec.describe Routes::BlogRoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  include Spec::Contexts::Helpers::RoutesHelperContexts

  it { expect(RoutesHelper).to be < described_class }

  describe '#blog_path' do
    it { expect(instance).to respond_to(:blog_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.blog_path nil).to be == '/' }
    end # describe

    describe 'with a root blog' do
      include_context 'with a root feature', :blog

      it { expect(instance.blog_path feature).to be == "/#{slug}" }
    end # describe

    describe 'with a non-root blog' do
      include_context 'with a non-root feature', :blog

      it { expect(instance.blog_path feature).to be == "/#{slugs.join '/'}" }

      context 'with empty slug' do
        let(:feature) { build(:blog, :directory => directories.last, :slug => nil) }

        it { expect(instance.blog_path feature).to be == "/#{slugs[0...-1].join '/'}" }
      end # context
    end # describe
  end # describe

  describe '#create_blog_path' do
    it { expect(instance).to respond_to(:create_blog_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.create_blog_path nil).to be == '/blogs' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.create_blog_path directory).to be == "/#{slug}/blogs" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.create_blog_path directories.last).to be == "/#{slugs.join '/'}/blogs" }
    end # describe
  end # describe

  describe '#edit_blog_path' do
    it { expect(instance).to respond_to(:edit_blog_path).with(1).argument }

    describe 'with a root feature' do
      include_context 'with a root feature', :blog

      it { expect(instance.edit_blog_path feature).to be == "/#{slug}/edit" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :blog

      it { expect(instance.edit_blog_path feature).to be == "/#{slugs.join '/'}/edit" }
    end # describe
  end # describe

  describe '#index_blogs_path' do
    it { expect(instance).to respond_to(:index_blogs_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.index_blogs_path nil).to be == '/blogs' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.index_blogs_path directory).to be == "/#{slug}/blogs" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.index_blogs_path directories.last).to be == "/#{slugs.join '/'}/blogs" }
    end # describe
  end # describe

  describe '#new_blog_path' do
    it { expect(instance).to respond_to(:new_blog_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.new_blog_path nil).to be == '/blogs/new' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.new_blog_path directory).to be == "/#{slug}/blogs/new" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.new_blog_path directories.last).to be == "/#{slugs.join '/'}/blogs/new" }
    end # describe
  end # describe
end # describe
