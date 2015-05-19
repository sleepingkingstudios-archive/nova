# spec/serializers/features/blog_post_serializer_spec.rb

require 'rails_helper'

require 'serializers/features/blog_post_serializer'

RSpec.describe BlogPostSerializer do
  include Spec::Contexts::SerializerContexts
  include Spec::Examples::SerializerExamples

  include_context 'with a serializer for', BlogPost

  before(:each) { blacklisted_attributes << 'blog_id' << 'content' }

  describe '#deserialize' do
    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return an instance of the resource'

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
    end # describe

    describe 'with attributes for a published post' do
      before(:each) { attributes['published_at'] = 1.day.ago }

      include_examples 'should return an instance of the resource', ->() {
        expect(resource.published_at).to be == attributes['published_at']
      } # end examples
    end # describe
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return the resource attributes', ->() {
      expect(serialized).to have_key 'published_at'
      expect(serialized.fetch('published_order')).to be == resource.published_at
    } # end examples

    context 'with a content' do
      before(:each) { resource.content = build(:text_content) }

      include_examples 'should return the resource attributes', ->() {
        expect(serialized).to have_key 'content'

        content = serialized.fetch('content')
        expect(content).to be == TextContentSerializer.serialize(resource.content)
      } # end examples
    end # context

    context 'with a published post' do
      before(:each) do
        resource.blog = create(:blog)
        resource.content = build(:content)
        resource.publish
        resource.save!
      end # before each

      include_examples 'should return the resource attributes', ->() {
        expect(serialized).to have_key 'published_at'
        expect(serialized.fetch('published_at')).to be == resource.published_at

        expect(serialized).to have_key 'published_order'
        expect(serialized.fetch('published_order')).to be == resource.published_order
      } # end examples
    end # context
  end # describe
end # describe
