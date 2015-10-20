# spec/helpers/routes/directory_routes_helper_spec.rb

require 'rails_helper'

RSpec.describe Routes::DirectoryRoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  include Spec::Contexts::Helpers::RoutesHelperContexts

  it { expect(RoutesHelper).to be < described_class }

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
end # describe
