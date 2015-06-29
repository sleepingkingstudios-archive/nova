# spec/helpers/decorators/serializers_helper_spec.rb

require 'rails_helper'

RSpec.describe Decorators::SerializersHelper, :type => :helper do
  shared_context 'with a custom class' do
    let(:value)          { 'value' }
    let(:resource_class) { Struct.new(:value) }
    let(:resource)       { resource_class.new(value) }

    before(:each) do
      Object.const_set :ValueHolder, resource_class
    end # before each

    after(:each) do
      Object.send :remove_const, :ValueHolder
    end # after each
  end # shared_context

  shared_context 'with a custom serializer' do
    include_context 'with a custom class'

    let(:serializer_class) do
      klass = Class.new(ResourceSerializer)
      klass.send :resource_class=, resource_class
      klass.attribute :value
      klass
    end # let

    before(:each) do
      Object.const_set :ValueHolderSerializer, serializer_class
    end # before each

    after(:each) do
      Object.send :remove_const, :ValueHolderSerializer
    end # after each
  end # shared_context

  let(:instance) { Object.new.extend described_class }

  describe '#deserialize' do
    let(:attributes) { { 'value' => 'value' } }
    let(:options)    { {} }

    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    context 'with a custom class' do
      include_context 'with a custom class'

      it 'should raise an error' do
        expect { instance.deserialize attributes, **options }.to raise_error ArgumentError, 'must specify a type'
      end # it

      describe 'with a specified type' do
        let(:options) { super().merge :type => resource_class }

        it 'should raise an error' do
          expect { instance.deserialize attributes, **options }.to raise_error StandardError, "undefined serializer for type #{resource_class}"
        end
      end
    end

    context 'with a custom serializer' do
      include_context 'with a custom serializer'

      let(:deserialized) { instance.deserialize(attributes, **options) }

      it 'should raise an error' do
        expect { instance.deserialize attributes, **options }.to raise_error ArgumentError, 'must specify a type'
      end # it

      describe 'with an implicit type' do
        let(:attributes) { super().merge '_type' => resource_class.name }

        it 'should return a resource' do
          expect(deserialized).to be_a resource_class
          expect(deserialized.value).to be == attributes['value']
        end # it
      end # describe

      describe 'with a specified type' do
        let(:options) { super().merge :type => resource_class }

        it 'should return a resource' do
          expect(deserialized).to be_a resource_class
          expect(deserialized.value).to be == attributes['value']
        end # it
      end # describe
    end # context
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    context 'with a custom class' do
      include_context 'with a custom class'

      it 'should raise an error' do
        expect { instance.serialize(resource) }.to raise_error StandardError, "undefined serializer for type #{resource_class}"
      end
    end

    context 'with a custom serializer' do
      include_context 'with a custom serializer'

      let(:serialized) { instance.serialize(resource) }
      let(:expected)   { { 'value' => 'value', '_type' => resource_class.name } }

      it { expect(serialized).to be == expected }
    end # context
  end # describe
end # describe
