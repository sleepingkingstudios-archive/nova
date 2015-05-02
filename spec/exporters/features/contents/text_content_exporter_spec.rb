# spec/exporters/features/contents/text_content_exporter_spec.rb

require 'rails_helper'

require 'exporters/features/contents/text_content_exporter'

RSpec.describe TextContentExporter do
  let(:blacklisted_attributes) { %w(_id) }

  it { expect(described_class).to be_constructible.with(0).arguments }

  describe '::instance' do
    it { expect(described_class).to have_reader(:instance).with(be_a described_class) }
  end # describe

  describe '::resource_class' do
    it { expect(described_class).to have_reader(:resource_class).with(TextContent) }
  end # describe

  describe '::deserialize' do
    let(:attributes) { attributes_for(:text_content).stringify_keys }

    it { expect(described_class).to respond_to(:deserialize).with(1).argument }

    it 'should return an instance of the resource class' do
      resource = described_class.deserialize attributes
      expect(resource).to be_a TextContent

      deserialized = resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) }

      attributes.each do |key, value|
        expect(deserialized[key.to_s]).to be == value
      end # each

      expect(deserialized.keys).to contain_exactly '_type', *attributes.keys
    end # it
  end # describe

  describe '::serialize' do
    it { expect(described_class).to respond_to(:serialize).with(1).argument }

    let(:resource) { build(:text_content) }

    it 'should return the resource attributes' do
      serialized = described_class.serialize resource
      expect(serialized).to be_a Hash

      attributes = resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) }
      attributes.each do |key, value|
        expect(serialized[key]).to be == resource.send(key)
      end # each

      expect(serialized.keys).to contain_exactly *attributes.keys
    end # it
  end # describe
end # describe
