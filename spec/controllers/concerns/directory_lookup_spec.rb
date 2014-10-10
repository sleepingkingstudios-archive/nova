# spec/controllers/concerns/directory_lookup_spec.rb

require 'rails_helper'

RSpec.describe DirectoryLookup, :type => :controller_concern do
  let(:method_stubs) { Module.new do def params; end; end }
  let(:instance)     { Object.new.extend(method_stubs).extend(described_class) }

  let(:params) { {}.with_indifferent_access }
  let(:assigns) do
    instance.instance_variables.each.with_object({}) do |key, hsh|
      hsh[key.to_s.sub(/\A@/, '')] = instance.instance_variable_get(key)
    end.with_indifferent_access
  end # let

  before(:each) { allow(instance).to receive(:params).and_return(params) }

  describe '#lookup_directories' do
    let(:directories) { [] }

    before(:each) do
      allow(Directory).to receive(:where) do |hsh|
        directories.select { |dir| dir.slug == hsh[:slug] }
      end # allow

      instance.metaclass.send :public, :lookup_directories
    end # before each

    it { expect(instance).to respond_to(:lookup_directories).with(0).arguments }

    describe 'with no directories in params' do
      it 'assigns @directories' do
        instance.lookup_directories

        expect(assigns.fetch :directories).to be == directories
        expect(assigns.fetch :current_directory).to be == directories.last
      end # it
    end # describe

    describe 'with a missing root directory' do
      let(:params) { super().merge :directories => 'items/weapons/swords' }

      it 'raises an error' do
        expect { instance.lookup_directories }.to raise_error Directory::NotFoundError do |exception|
          expect(exception.found).to be == directories
        end # expect
      end # it
    end # describe

    describe 'with a missing child directory' do
      let(:directories) do
        [double('directory', :slug => 'items')]
      end # let
      let(:params) { super().merge :directories => 'items/weapons/swords' }

      it 'raises an error' do
        expect { instance.lookup_directories }.to raise_error Directory::NotFoundError do |exception|
          expect(exception.found).to be == directories
        end # expect
      end # it
    end # describe

    describe 'with existing directories' do
      let(:directories) do
        %w(items weapons swords).map { |slug| double('directory', :slug => slug) }
      end # let
      let(:params) { super().merge :directories => 'items/weapons/swords' }

      it 'assigns @directories' do
        instance.lookup_directories

        expect(assigns.fetch :directories).to be == directories
        expect(assigns.fetch :current_directory).to be == directories.last
      end # it
    end # describe
  end # describe

  describe '#lookup_resource' do
    let(:directories) { [] }

    before(:each) do
      allow(Directory).to receive(:where) do |hsh|
        directories.select { |dir| dir.slug == hsh[:slug] }
      end # allow

      instance.metaclass.send :public, :lookup_resource
    end # before each

    it { expect(instance).to respond_to(:lookup_resource).with(0).arguments }

    describe 'with one root directory' do
      let(:directories) do
        [double('directory', :slug => 'items')]
      end # let
      let(:params) { super().merge :directories => 'items' }

      it 'assigns @resource' do
        instance.lookup_resource

        expect(assigns.fetch :directories).to be == directories
        expect(assigns.fetch :resource).to be == directories.last
      end # it
    end # describe

    describe 'with one root feature' do
      let(:feature) { double('feature', :slug => 'character-creation') }
      let(:params)  { super().merge :directories => 'character-creation' }

      before(:each) do
        allow(Feature).to receive(:roots).and_return(double('criteria', :where => [feature]))
      end # before

      it 'assigns @resource' do
        instance.lookup_resource

        expect(assigns.fetch :directories).to be == directories
        expect(assigns.fetch :resource).to be == feature
      end # it
    end # describe

    describe 'with one missing root directory or feature' do
      let(:segments) { %w(items) }
      let(:params)   { super().merge :directories => segments.join('/') }

      it 'raises an error' do
        expect { instance.lookup_resource }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
          expect(exception.search).to be == segments
          expect(exception.found).to be == directories
          expect(exception.missing).to be == segments[-1..-1]
        end # expect
      end # it
    end # describe

    describe 'with many missing root directories' do
      let(:params) { super().merge :directories => 'items/weapons/swords' }

      it 'raises an error' do
        expect { instance.lookup_resource }.to raise_error Directory::NotFoundError do |exception|
          expect(exception.found).to be == directories
        end # expect
      end # it
    end # describe

    describe 'with one child directory' do
      let(:directories) do
        [double('directory', :slug => 'items'), double('directory', :slug => 'weapons')]
      end # let
      let(:params) { super().merge :directories => 'items/weapons' }

      it 'assigns @resource' do
        instance.lookup_resource

        expect(assigns.fetch :directories).to be == directories
        expect(assigns.fetch :resource).to be == directories.last
      end # it
    end # describe

    describe 'with one child feature' do
      let(:feature) { double('feature', :slug => 'halberd') }
      let(:directories) do
        [ double('directory', :slug => 'items'),
          double('directory', :slug => 'weapons', :features => double('criteria', :where => [feature]))
        ] # end array
      end # let
      let(:params)  { super().merge :directories => 'items/weapons/halberd' }

      it 'assigns @resource' do
        instance.lookup_resource

        expect(assigns.fetch :directories).to be == directories
        expect(assigns.fetch :resource).to be == feature
      end # it
    end # describe

    describe 'with one missing child directory or feature' do
      let(:segments) { %w(items weapons swords) }
      let(:directories) do
        [ double('directory', :slug => 'items'),
          double('directory', :slug => 'weapons', :features => double('criteria', :where => []))
        ] # end array
      end # let
      let(:params)   { super().merge :directories => segments.join('/') }

      it 'raises an error' do
        expect { instance.lookup_resource }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
          expect(exception.search).to be == segments
          expect(exception.found).to be == directories
          expect(exception.missing).to be == segments[-1..-1]
        end # expect
      end # it
    end # describe

    describe 'with many missing child directories' do
      let(:directories) do
        [double('directory', :slug => 'items')]
      end # let
      let(:params) { super().merge :directories => 'items/weapons/swords' }

      it 'raises an error' do
        expect { instance.lookup_resource }.to raise_error Directory::NotFoundError do |exception|
          expect(exception.found).to be == directories
        end # expect
      end # it
    end # describe
  end # describe
end # describe
