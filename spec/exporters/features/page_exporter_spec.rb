# spec/exporters/features/page_exporter_spec.rb

require 'rails_helper'

require 'exporters/features/page_exporter'

RSpec.describe PageExporter do
  let(:blacklisted_attributes) { %w(_id _type content) }

  it { expect(described_class).to be_constructible.with(0).arguments }

  describe '::instance' do
    it { expect(described_class).to have_reader(:instance).with(be_a described_class) }
  end # describe

  describe '::resource_class' do
    it { expect(described_class).to have_reader(:resource_class).with(Page) }
  end # describe

  describe '::deserialize' do
    shared_examples 'should return a page' do
      it 'should return a page' do
        expect(resource).to be_a Page

        deserialized.each do |key, value|
          expect(attributes[key]).to be == value
        end # each

        expect(deserialized.keys).to contain_exactly *(attributes.keys - blacklisted_attributes)
      end # it
    end # shared_examples

    let(:attributes)   { build(:page).attributes.stringify_keys }
    let(:resource)     { described_class.deserialize attributes }
    let(:deserialized) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }

    it { expect(described_class).to respond_to(:deserialize).with(1).argument }

    include_examples 'should return a page'

    it 'should not create a page' do
      expect { described_class.deserialize attributes }.not_to change(Page, :count)
    end # it

    describe 'with attributes for a content' do
      let(:content_attributes) { build(:text_content).attributes.stringify_keys }

      before(:each) { attributes['content'] = content_attributes.merge :_type => 'TextContent' }

      include_examples 'should return a page'

      it 'should not create a page' do
        expect { described_class.deserialize attributes }.not_to change(BlogPost, :count)
      end # it

      it 'should return a page with a content' do
        expect(resource.content).to be_a TextContent

        deserialized = resource.content.attributes.reject { |key, _| ['_id', '_type'].include?(key.to_s) }

        deserialized.each do |key, value|
          expect(content_attributes[key]).to be == value
        end # each

        expect(deserialized.keys).to contain_exactly *(content_attributes.keys - ['_id', '_type'])
      end # it
    end # describe
  end # describe

  describe '::serialize' do
    shared_examples 'should return the page attributes' do
      it 'should return the page attributes' do
        expect(serialized).to be_a Hash

        attributes.each do |key, value|
          expect(serialized[key]).to be == resource.send(key)
        end # each
      end # it
    end # shared_examples

    let(:resource)   { build(:page) }
    let(:attributes) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }
    let(:serialized) { described_class.serialize(resource) }

    it { expect(described_class).to respond_to(:serialize).with(1).argument }

    it { expect(described_class.serialize(resource).keys).to contain_exactly '_type', 'content', *attributes.keys }

    include_examples 'should return the page attributes'

    describe 'with a published page' do
      before(:each) { resource.published_at = 1.day.ago }

      include_examples 'should return the page attributes'
    end # describe

    describe 'with a content' do
      let(:content)  { build(:text_content) }
      let(:expected) { TextContentExporter.serialize(content) }

      before(:each) { resource.content = content }

      it { expect(described_class.serialize(resource).keys).to contain_exactly '_type', 'content', *attributes.keys }

      it { expect(serialized.fetch('content')).to be == expected }

      include_examples 'should return the page attributes'
    end # describe
  end # describe
end # describe
