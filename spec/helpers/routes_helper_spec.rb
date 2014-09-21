# spec/helpers/routes_helper_spec.rb

require 'rails_helper'

RSpec.describe RoutesHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  describe '#directory_path' do
    it { expect(instance).to respond_to(:directory_path).with(0..9001).arguments }

    describe 'with no arguments' do
      it { expect(instance.directory_path).to be == '/' }
    end # describe

    describe 'with an array of strings' do
      let(:slugs) { %w(weapons swords japanese) }

      it { expect(instance.directory_path *slugs).to be == "/#{slugs.join '/'}" }
    end # describe

    describe 'with an array of directories' do
      let(:slugs) { %w(weapons swords japanese) }
      let(:directories) do
        %w(weapons swords japanese).map do |slug|
          build(:directory, :slug => slug)
        end # let
      end # let

      it { expect(instance.directory_path *directories).to be == "/#{slugs.join '/'}" }
    end # describe
  end # describe

  describe '#index_directory_path' do
    it { expect(instance).to respond_to(:index_directory_path).with(0..9001).arguments }

    describe 'with no arguments' do
      it { expect(instance.index_directory_path).to be == '/index' }
    end # describe

    describe 'with an array of strings' do
      let(:slugs) { %w(weapons swords japanese) }

      it { expect(instance.index_directory_path *slugs).to be == "/#{slugs.join '/'}/index" }
    end # describe

    describe 'with an array of directories' do
      let(:slugs) { %w(weapons swords japanese) }
      let(:directories) do
        %w(weapons swords japanese).map do |slug|
          build(:directory, :slug => slug)
        end # let
      end # let

      it { expect(instance.index_directory_path *directories).to be == "/#{slugs.join '/'}/index" }
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
