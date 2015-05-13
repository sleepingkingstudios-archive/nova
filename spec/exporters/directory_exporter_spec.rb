# spec/exporters/directory_exporter_spec.rb

require 'rails_helper'

require 'exporters/directory_exporter'

RSpec.describe DirectoryExporter do
  let(:blacklisted_attributes) { %w(_id _type parent_id) }

  it { expect(described_class).to be_constructible.with(0).arguments }

  describe '::instance' do
    it { expect(described_class).to have_reader(:instance).with(be_a described_class) }
  end # describe

  describe '::resource_class' do
    it { expect(described_class).to have_reader(:resource_class).with(Directory) }
  end # describe

  pending '::deserialize'

  describe '::serialize' do
    shared_examples 'should return the directory attributes' do
      it 'should return the directory attributes' do
        expect(serialized).to be_a Hash

        attributes.each do |key, value|
          expect(serialized[key]).to be == resource.send(key)
        end # each
      end # it
    end # shared_examples

    let(:resource)   { build(:directory) }
    let(:attributes) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }
    let(:serialized) { described_class.serialize(resource) }

    it { expect(described_class).to respond_to(:serialize).with(1).argument }

    it { expect(serialized.keys).to contain_exactly *attributes.keys }

    include_examples 'should return the directory attributes'

    pending 'should list the ancestors'

    describe 'with features' do
      let!(:pages) { Array.new(3) { create(:page, :directory => resource, :content => build(:content)) } }

      before(:each) do
        resource.save!
      end # before each

      it { expect(described_class.serialize(resource).keys).to contain_exactly *attributes.keys }

      include_examples 'should return the directory attributes'

      describe 'with relations => :all' do
        let(:serialized) { described_class.serialize(resource, :relations => :all) }
        let(:expected)   { pages.map { |page| PageExporter.serialize(page, :relations => :all) } }

        it { expect(serialized.keys).to contain_exactly 'directories', 'features', *attributes.keys }

        it 'should return the feature attributes' do
          expect(serialized.fetch 'features').to contain_exactly *expected
        end # it

        include_examples 'should return the directory attributes'
      end # describe
    end # describe

    describe 'with nested directories' do
      let(:resource) { create(:directory, :title => 'Weapons') }

      before(:each) do
        create(:page, :title => 'Bohemian Ear Spoon', :content => build(:content), :directory => resource)

        child = create(:directory, :title => 'Swords', :parent => resource)

        create(:page, :title => 'Zweihänder', :content => build(:content), :directory => child)

        grandchild = create(:directory, :title => 'Japanese', :parent => child)

        create(:page, :title => 'Daito', :content => build(:content), :directory => grandchild)
        create(:page, :title => 'Shoto', :content => build(:content), :directory => grandchild)
      end # before each

      it { expect(described_class.serialize(resource).keys).to contain_exactly *attributes.keys }

      include_examples 'should return the directory attributes'

      describe 'with relations => :all' do
        let(:serialized) { described_class.serialize(resource, :relations => :all) }

        def serialize_directory directory
          attributes = directory.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) }

          hsh = attributes.each.with_object({}) { |(attribute, value), hsh| hsh[attribute] = value }

          hsh['features'] = directory.features.map { |page| PageExporter.serialize(page, :relations => :all) }

          hsh['directories'] = directory.children.map { |child| serialize_directory(child) }

          hsh
        end # method serialize_directory

        it { expect(serialized).to be == serialize_directory(resource) }

        pending 'should list the ancestors'
      end # describe
    end # describe
  end # describe
end # describe
