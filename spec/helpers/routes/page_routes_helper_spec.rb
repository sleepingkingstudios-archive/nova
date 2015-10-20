# spec/helpers/routes/page_routes_helper_spec.rb

require 'rails_helper'

RSpec.describe Routes::PageRoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  include Spec::Contexts::Helpers::RoutesHelperContexts

  it { expect(RoutesHelper).to be < described_class }

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
