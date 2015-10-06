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

  shared_context 'with a model class' do
    let(:resource_class) do
      Class.new do
        include Mongoid::Document
        include Mongoid::Timestamps

        field :diameter, :type => Integer
      end # class
    end # let

    let(:serializer_class) do
      klass = Class.new(ResourceSerializer)
      klass.send :resource_class=, resource_class
      klass.attributes :diameter, :created_at, :updated_at
      klass
    end # let

    let(:attributes) { { :diameter => 10 } }
    let(:resource)   { resource_class.new(attributes) }

    before(:each) do
      Object.const_set :SelfSealingStemBolt,           resource_class
      Object.const_set :SelfSealingStemBoltSerializer, serializer_class
    end # before each

    after(:each) do
      Object.send :remove_const, :SelfSealingStemBolt
      Object.send :remove_const, :SelfSealingStemBoltSerializer
    end # after each
  end # shared_context

  let(:instance) { Object.new.extend described_class }

  describe '#deserialize' do
    let(:attributes) { { 'value' => 'value' } }
    let(:options)    { {} }

    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    wrap_context 'with a custom class' do
      it 'should raise an error' do
        expect { instance.deserialize attributes, **options }.to raise_error ArgumentError, 'must specify a type'
      end # it

      describe 'with a specified type' do
        let(:options) { super().merge :type => resource_class }

        it 'should raise an error' do
          expect { instance.deserialize attributes, **options }.to raise_error StandardError, "undefined serializer for type #{resource_class}"
        end # it
      end # describe
    end # wrap_context

    wrap_context 'with a custom serializer' do
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
    end # wrap_context

    wrap_context 'with a model class' do
      let(:deserialized) { instance.deserialize(attributes, **options) }
      let(:attributes)   { super().merge '_type' => resource_class.name }

      it 'should return a resource' do
        expect(deserialized).to be_a resource_class
        expect(deserialized.diameter).to be == attributes['diameter']
      end # it

      describe 'with serialized timestamps' do
        let(:created_at) { 1.month.ago }
        let(:updated_at) { 1.week.ago }
        let(:attributes) { super().merge :created_at => created_at.to_i, :updated_at => updated_at.to_i }

        it 'should return a resource' do
          expect(deserialized).to be_a resource_class
          expect(deserialized.diameter).to be == attributes['diameter']

          expect(deserialized.created_at).to be_a ActiveSupport::TimeWithZone
          expect(deserialized.created_at.to_i).to be == created_at.to_i

          expect(deserialized.updated_at).to be_a ActiveSupport::TimeWithZone
          expect(deserialized.updated_at.to_i).to be == updated_at.to_i
        end # it
      end # describe
    end # wrap_context
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    wrap_context 'with a custom class' do
      it 'should raise an error' do
        expect { instance.serialize(resource) }.to raise_error StandardError, "undefined serializer for type #{resource_class}"
      end # it
    end # wrap_context

    wrap_context 'with a custom serializer' do
      let(:serialized) { instance.serialize(resource) }
      let(:expected)   { { 'value' => 'value', '_type' => resource_class.name } }

      it { expect(serialized).to be == expected }
    end # wrap_context

    wrap_context 'with a model class' do
      let(:serialized) { instance.serialize(resource) }
      let(:expected)   { { 'diameter' => attributes[:diameter], '_type' => resource_class.name, 'created_at' => nil, 'updated_at' => nil } }

      it { expect(serialized).to be == expected }

      describe 'with timestamps' do
        let(:created_at) { 1.month.ago }
        let(:updated_at) { 1.week.ago }
        let(:attributes) { super().merge :created_at => created_at, :updated_at => updated_at }
        let(:expected)   { super().merge 'created_at' => created_at.to_i, 'updated_at' => updated_at.to_i }

        it { expect(serialized).to be == expected }
      end # describe
    end # wrap_context
  end # describe
end # describe
