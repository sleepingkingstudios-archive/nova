# spec/helpers/routes/resource_routes_helper_spec.rb

require 'rails_helper'

RSpec.describe Routes::ResourceRoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  include Spec::Contexts::Helpers::RoutesHelperContexts

  it { expect(RoutesHelper).to be < described_class }

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

  describe '#export_resource_path' do
    before(:each) { class << instance; public :export_resource_path; end }

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

  describe '#preview_resource_path' do
    before(:each) { class << instance; public :preview_resource_path; end }

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

  describe '#publish_resource_path' do
    before(:each) { class << instance; public :publish_resource_path; end }

    it { expect(instance).to respond_to(:publish_resource_path).with(1).argument }

    describe 'with a root feature' do
      include_context 'with a root feature', :directory_feature

      it { expect(instance.publish_resource_path feature).to be == "/#{slug}/publish" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :directory_feature

      it { expect(instance.publish_resource_path feature).to be == "/#{slugs.join '/'}/publish" }
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

  describe '#unpublish_resource_path' do
    before(:each) { class << instance; public :unpublish_resource_path; end }

    it { expect(instance).to respond_to(:unpublish_resource_path).with(1).argument }

    describe 'with a root feature' do
      include_context 'with a root feature', :directory_feature

      it { expect(instance.unpublish_resource_path feature).to be == "/#{slug}/unpublish" }
    end # describe

    describe 'with a non-root feature' do
      include_context 'with a non-root feature', :directory_feature

      it { expect(instance.unpublish_resource_path feature).to be == "/#{slugs.join '/'}/unpublish" }
    end # describe
  end # describe
end # describe
