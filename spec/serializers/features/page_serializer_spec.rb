# spec/serializers/features/page_serializer_spec.rb

require 'rails_helper'

require 'serializers/features/page_serializer'

RSpec.describe PageSerializer do
  include Spec::Contexts::SerializerContexts
  include Spec::Examples::SerializerExamples

  include_context 'with a serializer for', Page

  before(:each) { blacklisted_attributes << 'content' << 'directory' << 'directory_id' }

  describe '#deserialize' do
    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return an instance of the resource'

    before(:each) { expected.merge! 'slug' => attributes[:title].parameterize, 'slug_lock' => false }

    it 'should not persist the page' do
      expect { instance.deserialize attributes, **options }.not_to change(resource_class, :count)
    end # it

    describe 'with attributes for a content' do
      let(:content_attributes) { attributes_for(:text_content, :_type => 'TextContent').with_indifferent_access }

      before(:each) { attributes['content'] = content_attributes }

      include_examples 'should return an instance of the resource', ->() {
        content = resource.content
        expect(content).to be_a TextContent

        blacklisted_attributes = %w(_id _type)

        deserialized = content.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) }

        deserialized.each do |key, value|
          expect(content_attributes[key]).to be == value
        end # each

        expect(deserialized.keys).to include *(content_attributes.keys - blacklisted_attributes)
      } # end examples

      describe 'with :persist => true' do
        before(:each) { options[:persist] = true }

        it 'should persist the page' do
          expect { instance.deserialize attributes, **options }.to change(resource_class, :count).by(1)
        end # it
      end # describe
    end # describe

    describe 'with attributes for a published page' do
      before(:each) { attributes['published_at'] = expected['published_at'] = 1.day.ago }

      include_examples 'should return an instance of the resource', ->() {
        expect(resource.published_at).to be == attributes['published_at']
      } # end examples
    end # describe

    describe 'with a valid directory' do
      let(:directory) { create(:directory) }

      before(:each) { attributes[:directory] = directory.to_partial_path }

      include_examples 'should return an instance of the resource', ->() {
        expect(resource.directory).to be == directory
      } # end examples

      context 'with many ancestors' do
        let(:ancestors) { ary = Array.new(3).tap { |ary| ary.each_index { |index| ary[index] = create(:directory, :parent => ary[index - 1]) } } }
        let(:directory) { create(:directory, :parent => ancestors.last) }

        include_examples 'should return an instance of the resource', ->() {
          expect(resource.directory).to be == directory
        } # end examples
      end # context
    end # describe

    describe 'with an invalid directory' do
      before(:each) { attributes[:directory] = 'not/a/directory' }

      it 'should raise an error' do
        expect { instance.deserialize attributes }.to raise_error Directory::NotFoundError
      end # it

      it 'should not create a feature' do
        expect { begin; instance.deserialize attributes; rescue Directory::NotFoundError; end }.not_to change(DirectoryFeature, :count)
      end # it
    end # describe
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return the resource attributes', ->() {
      expect(serialized).to have_key 'published_at'
      expect(serialized.fetch('published_at')).to be == resource.published_at
    } # end examples

    context 'with a content' do
      before(:each) { resource.content = build(:text_content) }

      include_examples 'should return the resource attributes', ->() {
        expect(serialized).to have_key 'content'

        content = serialized.fetch('content')
        expect(content).to be == TextContentSerializer.serialize(resource.content)
      } # end examples
    end # context

    context 'with a published page' do
      before(:each) do
        resource.content = build(:content)
        resource.publish
        resource.save!
      end # before each

      include_examples 'should return the resource attributes', ->() {
        expect(serialized).to have_key 'published_at'
        expect(serialized.fetch('published_at')).to be == resource.published_at
      } # end examples
    end # context

    context 'with a directory' do
      let(:directory) { create(:directory) }

      before(:each) { resource.directory = directory }

      include_examples 'should return the resource attributes', ->() {
        expect(serialized).to have_key 'directory'
        expect(serialized['directory']).to be == directory.to_partial_path
      } # end examples

      context 'with many ancestors' do
        let(:ancestors) { ary = Array.new(3).tap { |ary| ary.each_index { |index| ary[index] = create(:directory, :parent => ary[index - 1]) } } }
        let(:directory) { create(:directory, :parent => ancestors.last) }

        include_examples 'should return the resource attributes', ->() {
          expect(serialized).to have_key 'directory'
          expect(serialized['directory']).to be == directory.to_partial_path
        } # end examples
      end # context
    end # context
  end # describe
end # describe
