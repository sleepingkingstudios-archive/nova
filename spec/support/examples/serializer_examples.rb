# spec/support/examples/serializer_examples.rb

require 'support/contexts/serializer_contexts'

module Spec
  module Examples
    module SerializerExamples
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      include Spec::Contexts::SerializerContexts

      shared_examples 'should return an instance of the resource' do |proc|
        let(:attributes)   { {} }
        let(:options)      { {} }
        let(:resource)     { instance.deserialize attributes, **options }
        let(:deserialized) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }

        it 'should return an instance of the resource' do
          expect(resource).to be_a resource_class

          deserialized.each do |key, value|
            expect(attributes[key]).to be == value
          end # each

          expect(deserialized.keys).to include *(attributes.keys - blacklisted_attributes)

          SleepingKingStudios::Tools::ObjectTools.apply self, proc if proc.respond_to?(:call)
        end # it
      end # shared_examples

      shared_examples 'should return the resource attributes' do |proc|
        let(:resource)   { build(resource_class) }
        let(:attributes) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }
        let(:options)    { {} }
        let(:serialized) { described_class.serialize(resource, **options) }

        it 'should return the resource attributes' do
          expect(serialized).to be_a Hash

          expect(serialized.keys).to include '_type', *attributes.keys

          expect(serialized.fetch('_type')).to be == resource_class.name

          attributes.each do |attribute_name, value|
            expect(serialized.fetch(attribute_name)).to be == value
          end # each

          SleepingKingStudios::Tools::ObjectTools.apply self, proc if proc.respond_to?(:call)
        end # it
      end # shared_examples
    end # module
  end # module
end # module
