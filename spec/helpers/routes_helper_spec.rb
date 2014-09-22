# spec/helpers/routes_helper_spec.rb

require 'rails_helper'

RSpec.describe RoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  shared_examples 'with a root directory', :directories => :one do
    let(:slug)      { 'weapons' }
    let(:directory) { build(:directory, :slug => slug) }
  end # shared_examples

  shared_examples 'with a non-root directory', :directories => :many do
    let(:slugs) { %w(weapons swords japanese) }
    let(:directories) do
      [].tap do |ary|
        slugs.each do |slug|
          ary << create(:directory, :parent => ary[-1], :title => slug.capitalize)
        end # each
      end # tap
    end # let
  end # shared_examples

  describe '#create_directory_path' do
    it { expect(instance).to respond_to(:create_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.create_directory_path nil).to be == '/directories' }
    end # describe

    describe 'with a root directory', :directories => :one do
      it { expect(instance.create_directory_path directory).to be == "/#{slug}/directories" }
    end # describe

    describe 'with a non-root directory', :directories => :many do
      it { expect(instance.create_directory_path directories.last).to be == "/#{slugs.join '/'}/directories" }
    end # describe
  end # describe

  describe '#dashboard_directory_path' do
    it { expect(instance).to respond_to(:dashboard_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.dashboard_directory_path nil).to be == '/dashboard' }
    end # describe

    describe 'with a root directory', :directories => :one do
      it { expect(instance.dashboard_directory_path directory).to be == "/#{slug}/dashboard" }
    end # describe

    describe 'with a non-root directory', :directories => :many do
      it { expect(instance.dashboard_directory_path directories.last).to be == "/#{slugs.join '/'}/dashboard" }
    end # describe
  end # describe

  describe '#directory_path' do
    it { expect(instance).to respond_to(:directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.directory_path nil).to be == '/' }
    end # describe

    describe 'with a root directory', :directories => :one do
      it { expect(instance.directory_path directory).to be == "/#{slug}" }
    end # describe

    describe 'with a non-root directory', :directories => :many do
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

    describe 'with a root directory', :directories => :one do
      it { expect(instance.edit_directory_path directory).to be == "/#{slug}/edit" }
    end # describe

    describe 'with a non-root directory', :directories => :many do
      it { expect(instance.edit_directory_path directories.last).to be == "/#{slugs.join '/'}/edit" }
    end # describe
  end # describe

  describe '#index_directory_path' do
    it { expect(instance).to respond_to(:index_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.index_directory_path nil).to be == '/index' }
    end # describe

    describe 'with a root directory', :directories => :one do
      it { expect(instance.index_directory_path directory).to be == "/#{slug}/index" }
    end # describe

    describe 'with a non-root directory', :directories => :many do
      it { expect(instance.index_directory_path directories.last).to be == "/#{slugs.join '/'}/index" }
    end # describe
  end # describe

  describe '#new_directory_path' do
    it { expect(instance).to respond_to(:new_directory_path).with(1).arguments }

    describe 'with nil' do
      it { expect(instance.new_directory_path nil).to be == '/directories/new' }
    end # describe

    describe 'with a root directory', :directories => :one do
      it { expect(instance.new_directory_path directory).to be == "/#{slug}/directories/new" }
    end # describe

    describe 'with a non-root directory', :directories => :many do
      it { expect(instance.new_directory_path directories.last).to be == "/#{slugs.join '/'}/directories/new" }
    end # describe
  end # describe
end # describe

RSpec.describe 'Rails url_helpers' do
  let(:instance) { Object.new.extend Rails.application.routes.url_helpers }
  let(:methods)  { Object.new.extend(RoutesHelper).methods - Object.new.methods }

  it 'includes the helper methods' do
    methods.each do |method|
      expect(instance).to respond_to(method)
    end # each
  end # it
end # describe
