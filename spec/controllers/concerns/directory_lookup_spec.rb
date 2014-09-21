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
end # describe
