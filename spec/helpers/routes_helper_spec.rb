# spec/helpers/routes_helper_spec.rb

require 'rails_helper'

RSpec.describe RoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  shared_context 'with a root directory' do
    let(:slug)      { 'weapons' }
    let(:directory) { build(:directory, :slug => slug) }
  end # shared_context

  shared_context 'with a root feature' do |feature_type|
    let(:slug)    { 'character-creation' }
    let(:feature) { build(feature_type, :slug => slug) }
  end # shared_context

  shared_context 'with a non-root directory' do
    let(:slugs) { %w(weapons swords japanese) }
    let(:directories) do
      [].tap do |ary|
        slugs.each do |slug|
          ary << create(:directory, :parent => ary[-1], :title => slug.capitalize)
        end # each
      end # tap
    end # let
  end # shared_context

  shared_context 'with a non-root feature' do |feature_type|
    let(:slugs) { %w(weapons swords japanese tachi) }
    let(:directories) do
      [].tap do |ary|
        slugs[0...-1].each do |slug|
          ary << create(:directory, :parent => ary[-1], :title => slug.capitalize)
        end # each
      end # tap
    end # let
    let(:feature) { build(feature_type, :slug => slugs.last, :directory => directories.last) }
  end # shared_context

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

  describe '#create_directory_path' do
    it { expect(instance).to respond_to(:create_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.create_directory_path nil).to be == '/directories' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.create_directory_path directory).to be == "/#{slug}/directories" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.create_directory_path directories.last).to be == "/#{slugs.join '/'}/directories" }
    end # describe
  end # describe

  describe '#create_page_path' do
    it { expect(instance).to respond_to(:create_page_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.create_page_path nil).to be == '/pages' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.create_page_path directory).to be == "/#{slug}/pages" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.create_page_path directories.last).to be == "/#{slugs.join '/'}/pages" }
    end # describe
  end # describe

  describe '#create_resource_path' do
    it { expect(instance).to respond_to(:create_resource_path).with(2).arguments }

    describe 'with nil' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.create_resource_path nil, resource_name).to be == "/#{resource_name.tableize}" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.create_resource_path nil, resource_class).to be == "/#{resource_class.to_s.tableize}" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.create_resource_path nil, resource).to be == "/#{resource.class.to_s.tableize}" }
      end # describe
    end # describe

    wrap_context 'with a root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.create_resource_path directory, resource_name).to be == "/#{slug}/#{resource_name.tableize}" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.create_resource_path directory, resource_class).to be == "/#{slug}/#{resource_class.to_s.tableize}" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.create_resource_path directory, resource).to be == "/#{slug}/#{resource.class.to_s.tableize}" }
      end # describe
    end # describe

    wrap_context 'with a non-root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.create_resource_path directories.last, resource_name).to be == "/#{slugs.join '/'}/#{resource_name.tableize}" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.create_resource_path directories.last, resource_class).to be == "/#{slugs.join '/'}/#{resource_class.to_s.tableize}" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.create_resource_path directories.last, resource).to be == "/#{slugs.join '/'}/#{resource.class.to_s.tableize}" }
      end # describe
    end # describe
  end # describe

  describe '#dashboard_directory_path' do
    it { expect(instance).to respond_to(:dashboard_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.dashboard_directory_path nil).to be == '/dashboard' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.dashboard_directory_path directory).to be == "/#{slug}/dashboard" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.dashboard_directory_path directories.last).to be == "/#{slugs.join '/'}/dashboard" }
    end # describe
  end # describe

  describe '#directory_path' do
    it { expect(instance).to respond_to(:directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.directory_path nil).to be == '/' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.directory_path directory).to be == "/#{slug}" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.directory_path directories.last).to be == "/#{slugs.join '/'}" }

      context 'with empty slug' do
        let(:directory) { build(:directory, :parent => directories.last, :slug => nil) }

        it { expect(instance.directory_path directory).to be == "/#{slugs.join '/'}" }
      end # context
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

  describe '#edit_directory_path' do
    it { expect(instance).to respond_to(:edit_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.edit_directory_path nil).to be == '/edit' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.edit_directory_path directory).to be == "/#{slug}/edit" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.edit_directory_path directories.last).to be == "/#{slugs.join '/'}/edit" }
    end # describe
  end # describe

  describe '#edit_page_path' do
    it { expect(instance).to respond_to(:edit_page_path).with(1).argument }

    describe 'with a root feature' do
      include_context 'with a root feature', :page

      it { expect(instance.edit_page_path feature).to be == "/#{slug}/edit" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :page

      it { expect(instance.edit_page_path feature).to be == "/#{slugs.join '/'}/edit" }
    end # describe
  end # describe

  describe '#edit_resource_path' do
    it { expect(instance).to respond_to(:edit_resource_path).with(1).argument }

    describe 'with a root feature' do
      include_context 'with a root feature', :directory_feature

      it { expect(instance.edit_resource_path feature).to be == "/#{slug}/edit" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :directory_feature

      it { expect(instance.edit_resource_path feature).to be == "/#{slugs.join '/'}/edit" }
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

  describe '#export_directory_path' do
    it { expect(instance).to respond_to(:export_directory_path).with(1).arguments.and_keywords(:pretty) }

    describe 'with nil' do
      it { expect(instance.export_directory_path nil).to be == '/export' }

      describe 'with :pretty => true' do
        it { expect(instance.export_directory_path nil, :pretty => true).to be == '/export?pretty=true' }
      end # describe
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.export_directory_path directory).to be == "/#{slug}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_directory_path directory, :pretty => true).to be == "/#{slug}/export?pretty=true" }
      end # describe
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.export_directory_path directories.last).to be == "/#{slugs.join '/'}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_directory_path directories.last, :pretty => true).to be == "/#{slugs.join '/'}/export?pretty=true" }
      end # describe
    end # describe
  end # describe

  describe '#export_page_path' do
    it { expect(instance).to respond_to(:export_page_path).with(1).argument.and_keywords(:pretty) }

    describe 'with a root feature' do
      include_context 'with a root feature', :directory_feature

      it { expect(instance.export_page_path feature).to be == "/#{slug}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_page_path feature, :pretty => true).to be == "/#{slug}/export?pretty=true" }
      end # describe
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :directory_feature

      it { expect(instance.export_page_path feature).to be == "/#{slugs.join '/'}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_page_path feature, :pretty => true).to be == "/#{slugs.join '/'}/export?pretty=true" }
      end # describe
    end # describe
  end # describe

  describe '#export_resource_path' do
    it { expect(instance).to respond_to(:export_resource_path).with(1).argument.and_keywords(:pretty) }

    describe 'with a root feature' do
      include_context 'with a root feature', :directory_feature

      it { expect(instance.export_resource_path feature).to be == "/#{slug}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_resource_path feature, :pretty => true).to be == "/#{slug}/export?pretty=true" }
      end # describe
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :directory_feature

      it { expect(instance.export_resource_path feature).to be == "/#{slugs.join '/'}/export" }

      describe 'with :pretty => true' do
        it { expect(instance.export_resource_path feature, :pretty => true).to be == "/#{slugs.join '/'}/export?pretty=true" }
      end # describe
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

  describe '#index_directories_path' do
    it { expect(instance).to respond_to(:index_directories_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.index_directories_path nil).to be == '/directories' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.index_directories_path directory).to be == "/#{slug}/directories" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.index_directories_path directories.last).to be == "/#{slugs.join '/'}/directories" }
    end # describe
  end # describe

  describe '#index_pages_path' do
    it { expect(instance).to respond_to(:index_pages_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.index_pages_path nil).to be == '/pages' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.index_pages_path directory).to be == "/#{slug}/pages" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.index_pages_path directories.last).to be == "/#{slugs.join '/'}/pages" }
    end # describe
  end # describe

  describe '#index_resources_path' do
    it { expect(instance).to respond_to(:index_resources_path).with(2).arguments }

    describe 'with nil' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.index_resources_path nil, resource_name).to be == "/#{resource_name.tableize}" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.index_resources_path nil, resource_class).to be == "/#{resource_class.to_s.tableize}" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.index_resources_path nil, resource).to be == "/#{resource.class.to_s.tableize}" }
      end # describe
    end # describe

    wrap_context 'with a root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.index_resources_path directory, resource_name).to be == "/#{slug}/#{resource_name.tableize}" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.index_resources_path directory, resource_class).to be == "/#{slug}/#{resource_class.to_s.tableize}" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.index_resources_path directory, resource).to be == "/#{slug}/#{resource.class.to_s.tableize}" }
      end # describe
    end # describe

    wrap_context 'with a non-root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.index_resources_path directories.last, resource_name).to be == "/#{slugs.join '/'}/#{resource_name.tableize}" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.index_resources_path directories.last, resource_class).to be == "/#{slugs.join '/'}/#{resource_class.to_s.tableize}" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.index_resources_path directories.last, resource).to be == "/#{slugs.join '/'}/#{resource.class.to_s.tableize}" }
      end # describe
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

  describe '#new_directory_path' do
    it { expect(instance).to respond_to(:new_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.new_directory_path nil).to be == '/directories/new' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.new_directory_path directory).to be == "/#{slug}/directories/new" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.new_directory_path directories.last).to be == "/#{slugs.join '/'}/directories/new" }
    end # describe
  end # describe

  describe '#new_page_path' do
    it { expect(instance).to respond_to(:new_page_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.new_page_path nil).to be == '/pages/new' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.new_page_path directory).to be == "/#{slug}/pages/new" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.new_page_path directories.last).to be == "/#{slugs.join '/'}/pages/new" }
    end # describe
  end # describe

  describe '#new_resource_path' do
    it { expect(instance).to respond_to(:new_resource_path).with(2).arguments }

    describe 'with nil' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.new_resource_path nil, resource_name).to be == "/#{resource_name.tableize}/new" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.new_resource_path nil, resource_class).to be == "/#{resource_class.to_s.tableize}/new" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.new_resource_path nil, resource).to be == "/#{resource.class.to_s.tableize}/new" }
      end # describe
    end # describe

    wrap_context 'with a root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.new_resource_path directory, resource_name).to be == "/#{slug}/#{resource_name.tableize}/new" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.new_resource_path directory, resource_class).to be == "/#{slug}/#{resource_class.to_s.tableize}/new" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.new_resource_path directory, resource).to be == "/#{slug}/#{resource.class.to_s.tableize}/new" }
      end # describe
    end # describe

    wrap_context 'with a non-root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.new_resource_path directories.last, resource_name).to be == "/#{slugs.join '/'}/#{resource_name.tableize}/new" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.new_resource_path directories.last, resource_class).to be == "/#{slugs.join '/'}/#{resource_class.to_s.tableize}/new" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.new_resource_path directories.last, resource).to be == "/#{slugs.join '/'}/#{resource.class.to_s.tableize}/new" }
      end # describe
    end # describe
  end # describe

  describe '#page_path' do
    it { expect(instance).to respond_to(:page_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.page_path nil).to be == '/' }
    end # describe

    describe 'with a root feature' do
      include_context 'with a root feature', :page

      it { expect(instance.page_path feature).to be == "/#{slug}" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :page

      it { expect(instance.page_path feature).to be == "/#{slugs.join '/'}" }

      context 'with empty slug' do
        let(:feature) { build(:page, :directory => directories.last, :slug => nil) }

        it { expect(instance.page_path feature).to be == "/#{slugs[0...-1].join '/'}" }
      end # context
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

  describe '#preview_page_path' do
    it { expect(instance).to respond_to(:preview_page_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.preview_page_path nil).to be == '/pages/preview' }
    end # describe

    wrap_context 'with a root directory' do
      it { expect(instance.preview_page_path directory).to be == "/#{slug}/pages/preview" }
    end # describe

    wrap_context 'with a non-root directory' do
      it { expect(instance.preview_page_path directories.last).to be == "/#{slugs.join '/'}/pages/preview" }
    end # describe
  end # describe

  describe '#preview_resource_path' do
    it { expect(instance).to respond_to(:preview_resource_path).with(2).arguments }

    describe 'with nil' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.preview_resource_path nil, resource_name).to be == "/#{resource_name.tableize}/preview" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.preview_resource_path nil, resource_class).to be == "/#{resource_class.to_s.tableize}/preview" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.preview_resource_path nil, resource).to be == "/#{resource.class.to_s.tableize}/preview" }
      end # describe
    end # describe

    wrap_context 'with a root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.preview_resource_path directory, resource_name).to be == "/#{slug}/#{resource_name.tableize}/preview" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.preview_resource_path directory, resource_class).to be == "/#{slug}/#{resource_class.to_s.tableize}/preview" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.preview_resource_path directory, resource).to be == "/#{slug}/#{resource.class.to_s.tableize}/preview" }
      end # describe
    end # describe

    wrap_context 'with a non-root directory' do
      describe 'with a resource name' do
        let(:resource_name) { 'features' }

        it { expect(instance.preview_resource_path directories.last, resource_name).to be == "/#{slugs.join '/'}/#{resource_name.tableize}/preview" }
      end # describe

      describe 'with a resource class' do
        let(:resource_class) { Feature }

        it { expect(instance.preview_resource_path directories.last, resource_class).to be == "/#{slugs.join '/'}/#{resource_class.to_s.tableize}/preview" }
      end # describe

      describe 'with a resource instance' do
        let(:resource) { build(:directory_feature) }

        it { expect(instance.preview_resource_path directories.last, resource).to be == "/#{slugs.join '/'}/#{resource.class.to_s.tableize}/preview" }
      end # describe
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

  describe '#publish_page_path' do
    it { expect(instance).to respond_to(:publish_page_path).with(1).argument }

    describe 'with a root feature' do
      include_context 'with a root feature', :page

      it { expect(instance.publish_page_path feature).to be == "/#{slug}/publish" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :page

      it { expect(instance.publish_page_path feature).to be == "/#{slugs.join '/'}/publish" }
    end # describe
  end # describe

  describe '#resource_path' do
    it { expect(instance).to respond_to(:resource_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.resource_path nil).to be == '/' }
    end # describe

    describe 'with a root feature' do
      include_context 'with a root feature', :directory_feature

      it { expect(instance.resource_path feature).to be == "/#{slug}" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :directory_feature

      it { expect(instance.resource_path feature).to be == "/#{slugs.join '/'}" }

      context 'with empty slug' do
        let(:feature) { build(:directory_feature, :directory => directories.last, :slug => nil) }

        it { expect(instance.resource_path feature).to be == "/#{slugs[0...-1].join '/'}" }
      end # context
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

  describe '#unpublish_page_path' do
    it { expect(instance).to respond_to(:unpublish_page_path).with(1).argument }

    describe 'with a root feature' do
      include_context 'with a root feature', :page

      it { expect(instance.unpublish_page_path feature).to be == "/#{slug}/unpublish" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :page

      it { expect(instance.unpublish_page_path feature).to be == "/#{slugs.join '/'}/unpublish" }
    end # describe
  end # describe
end # describe
