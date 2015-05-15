# spec/serializers/resource_serializer_spec.rb

require 'rails_helper'

require 'serializers/resource_serializer'

RSpec.describe ResourceSerializer do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  shared_context 'with permitted attributes' do
    let(:permitted_attributes) { %w(title) }

    before(:each) do
      described_class.attributes *permitted_attributes
    end # before each
  end # shared_context

  let(:resource_class) { Feature }
  let(:described_class) do
    klass = Class.new(ResourceSerializer)
    klass.send :resource_class=, resource_class
    klass
  end # let

  describe ResourceSerializer::DSL::Attributes do
    describe '::attribute' do
      it { expect(described_class).to respond_to(:attribute).with(1).argument }
    end # describe

    describe '::attributes' do
      it { expect(described_class).to respond_to(:attributes).with(1..9001).arguments }
    end # describe

    describe '::permitted_attributes' do
      it { expect(described_class).to have_reader(:permitted_attributes).with_value(be_a(Set).&(be_empty)) }

      describe 'with permitted attributes' do
        include_context 'with permitted attributes'

        it { expect(described_class.permitted_attributes).to contain_exactly 'title' }

        describe 'with a subclass' do
          let(:subclass) do
            klass = Class.new(described_class)
            klass.attribute :slug
            klass
          end # let

          it { expect(subclass.permitted_attributes).to contain_exactly 'title', 'slug' }
        end # describe
      end # describe
    end # describe
  end # describe

  describe ResourceSerializer::DSL::Relations do
    describe '::embeds_many' do
      let(:relation_name) { :relation }

      it { expect(described_class).to respond_to(:embeds_many).with(1).argument }

      it 'should delegate to ::relates' do
        expect(described_class).to receive(:relates).with(relation_name, :embedded => true, :plurality => :many)

        described_class.embeds_many relation_name
      end # it
    end # describe

    describe '::embeds_one' do
      let(:relation_name) { :relation }

      it { expect(described_class).to respond_to(:embeds_one).with(1).argument }

      it 'should delegate to ::relates' do
        expect(described_class).to receive(:relates).with(relation_name, :embedded => true, :plurality => :one)

        described_class.embeds_one relation_name
      end # it
    end # describe

    describe '::has_many' do
      let(:relation_name) { :relation }

      it { expect(described_class).to respond_to(:has_many).with(1).argument }

      it 'should delegate to ::relates' do
        expect(described_class).to receive(:relates).with(relation_name, :embedded => false, :plurality => :many)

        described_class.has_many relation_name
      end # it
    end # describe

    describe '::has_one' do
      let(:relation_name) { :relation }

      it { expect(described_class).to respond_to(:has_one).with(1).argument }

      it 'should delegate to ::relates' do
        expect(described_class).to receive(:relates).with(relation_name, :embedded => false, :plurality => :one)

        described_class.has_one relation_name
      end # it
    end # describe

    describe '::relates' do
      before(:each) { described_class::DSL::Relations::ClassMethods.send :public, :relates }

      it { expect(described_class).to respond_to(:relates, true).with(1, :embedded, :plurality).arguments }

      describe 'name must be unique' do
        it 'should raise an error' do
          described_class.relates :relation, :embedded => true, :plurality => :one

          expect { described_class.relates :relation, :embedded => true, :plurality => :one }.to raise_error ArgumentError
        end # it
      end # describe

      describe 'plurality must be :one or :many' do
        it { expect { described_class.relates :relation, :embedded => false, :plurality => :one }.not_to raise_error }

        it { expect { described_class.relates :relation, :embedded => false, :plurality => :many }.not_to raise_error }

        it 'should raise an error' do
          expect { described_class.relates :relation, :embedded => false, :plurality => :some }.to raise_error ArgumentError
        end # it
      end # describe
    end # describe
  end # describe

  it { expect(described_class).to be_constructible.with(0, :arbitrary, :keywords) }

  describe '::resource_class' do
    it { expect(described_class).to have_reader(:resource_class).with(resource_class) }

    it { expect(described_class).not_to have_writer(:resource_class=) }

    describe 'with a named subclass' do
      before(:each) do
        class CustomFeature < Feature; end

        class CustomFeatureSerializer < ResourceSerializer; end
      end # before each

      after(:each) do
        Object.send :remove_const, :CustomFeatureSerializer
        Object.send :remove_const, :CustomFeature
      end # after each

      let(:resource_class)  { CustomFeature }
      let(:described_class) { CustomFeatureSerializer }

      it { expect(described_class.resource_class).to be == resource_class }
    end # describe
  end # describe

  let(:instance_options)  { {} }
  let(:instance)          { described_class.new(**instance_options) }

  describe '#deserialize' do
    let(:attributes)   { attributes_for(:feature).with_indifferent_access }
    let(:options)      { {} }
    let(:deserialized) { instance.deserialize attributes, **options }

    it { expect(instance).to respond_to(:deserialize).with(1, :type, :arbitrary, :keywords) }

    it 'should return an instance of the resource' do
      expect(deserialized).to be_a resource_class

      attributes.keys.each do |attribute_name|
        expect(deserialized.send attribute_name).to be nil
      end # each
    end # it

    context 'with permitted attributes' do
      include_context 'with permitted attributes'

      it 'should return an instance of the resource' do
        expect(deserialized).to be_a resource_class

        permitted_attributes.each do |attribute_name|
          expect(deserialized.send attribute_name).to be == attributes[attribute_name]
        end # each
      end # it
    end # context
  end # describe

  describe '#serialize' do
    let(:resource)   { resource_class.new(attributes_for :feature) }
    let(:options)    { {} }
    let(:serialized) { instance.serialize resource, **options }

    it { expect(instance).to respond_to(:serialize).with(1, :relations, :arbitrary, :keywords) }

    it { expect(serialized).to be == {} }

    context 'with errors on the resource' do
      let(:resource) { resource_class.new(attributes_for :feature, :title => nil).tap &:valid? }

      it 'should return the resource error messages' do
        expect(serialized).to be_a Hash

        expect(serialized.keys).to contain_exactly 'errors'

        expect(serialized.fetch('errors')).to contain_exactly *resource.errors.full_messages
      end # it
    end # context

    context 'with permitted attributes' do
      include_context 'with permitted attributes'

      it 'should return the resource attributes' do
        expect(serialized).to be_a Hash

        expect(serialized.keys).to contain_exactly *permitted_attributes

        permitted_attributes.each do |attribute_name|
          expect(resource.send attribute_name).to be == serialized[attribute_name]
        end # each
      end # it
    end # context
  end # describe
end # describe
