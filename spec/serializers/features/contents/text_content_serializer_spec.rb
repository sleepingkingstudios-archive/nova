# spec/serializers/features/contents/text_content_serializer_spec.rb

require 'rails_helper'

require 'serializers/features/contents/text_content_serializer'

RSpec.describe TextContentSerializer do
  include Spec::Contexts::SerializerContexts
  include Spec::Examples::SerializerExamples

  include_context 'with a serializer for', TextContent

  describe '#deserialize' do
    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return an instance of the resource'
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return the resource attributes'
  end # describe
end # describe
