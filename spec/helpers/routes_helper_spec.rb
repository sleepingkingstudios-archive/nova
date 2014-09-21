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

  describe '#directories_path' do
    it { expect(instance).to respond_to(:directories_path).with(0..9001).arguments }

    describe 'with no arguments' do
      it { expect(instance.directories_path).to be == '/' }
    end # describe

    describe 'with an array of strings' do
      let(:slugs) { %w(weapons swords japanese) }

      it { expect(instance.directories_path *slugs).to be == "/#{slugs.join '/'}" }
    end # describe

    describe 'with an array of directories' do
      let(:slugs) { %w(weapons swords japanese) }
      let(:directories) do
        %w(weapons swords japanese).map do |slug|
          build(:directory, :slug => slug)
        end # let
      end # let

      it { expect(instance.directories_path *directories).to be == "/#{slugs.join '/'}" }
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
