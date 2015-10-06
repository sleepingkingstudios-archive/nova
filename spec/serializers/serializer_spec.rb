# spec/serializers/serializer_spec.rb

require 'rails_helper'

require 'serializers/serializer'

RSpec.describe Serializer do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  shared_context 'with default options from the class' do
    let(:class_options) { { :width => 640, :height => 480, :refresh => '60Hz' } }

    before(:each) { allow(described_class).to receive(:default_options).and_return(class_options) }
  end # shared_context

  shared_context 'with default options from the instance' do
    let(:instance_options) { { :refresh => '50Hz', :interlaced => false } }
  end # shared_context

  shared_context 'with permitted attributes' do
    let(:permitted_attributes) { %w(width height refresh) }

    before(:each) do
      allow(instance).to receive(:permitted_attributes).and_return(permitted_attributes)
    end # before each
  end # shared_context

  shared_context 'with a resource class' do
    let(:resource_class) do
      Class.new do
        def initialize width = nil, height = nil, refresh = nil, interlaced = nil, purchased_at = nil
          @data = {
            :width        => width,
            :height       => height,
            :refresh      => refresh,
            :interlaced   => interlaced,
            :purchased_at => purchased_at
          }.with_indifferent_access # end hash
        end # constructor

        def [] key
          @data[key]
        end # method []

        def []= key, value
          @data[key] = value
        end # method []=

        %w(width height refresh interlaced purchased_at).each do |attribute_name|
          define_method(attribute_name) { @data[attribute_name] }

          define_method(:"#{attribute_name}=") { |value| @data[attribute_name] = value }
        end # each
      end # class
    end # let
  end # shared_context

  shared_examples 'should delegate to an instance' do |method_name|
    it 'should delegate to an instance' do
      arguments    = %w(foo bar baz)
      keywords     = { :wibble => 'wobble' }
      block_called = false
      instance     = double(method_name => nil)

      allow(described_class).to receive(:new).and_return(instance)

      expect(instance).to receive(method_name) do |*args, **kwargs, &block|
        expect(args).to be   == arguments
        expect(kwargs).to be == keywords

        block.call
      end # expect

      described_class.send(method_name, *arguments, **keywords) { block_called = true }

      expect(block_called).to be true
    end # it
  end # shared_examples

  it { expect(described_class).to be_constructible.with(0, :arbitrary, :keywords) }

  describe '::default_options' do
    it { expect(described_class).to have_reader(:default_options).with({}) }
  end # describe

  include_examples 'should delegate to an instance', :deserialize

  include_examples 'should delegate to an instance', :serialize

  let(:instance_options)  { {} }
  let(:instance)          { described_class.new(**instance_options) }

  describe '#default_options' do
    it { expect(instance).to have_reader(:default_options).with({}) }

    describe 'with default options from the class' do
      include_context 'with default options from the class'

      it { expect(instance.default_options).to be == class_options }
    end # describe

    describe 'with default options from the instance' do
      include_context 'with default options from the instance'

      it { expect(instance.default_options).to be == instance_options }
    end # describe

    describe 'with default options from the class and the instance' do
      include_context 'with default options from the class'
      include_context 'with default options from the instance'

      let(:expected_options) { class_options.merge(instance_options) }

      it { expect(instance.default_options).to be == expected_options }
    end # describe
  end # describe

  describe '#permitted_attributes' do
    it { expect(instance).to have_reader(:permitted_attributes).with([]) }
  end # describe

  describe '#deserialize' do
    include_examples 'with a resource class'

    let(:attributes)   { { :width => 640, :height => 480, :refresh => '60Hz', :interlaced => false }.with_indifferent_access }
    let(:options)      { {} }
    let(:deserialized) { instance.deserialize attributes, :type => resource_class, **options }

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

      describe 'with a method on the object' do
        let(:custom_refresh) { '50Hz' }

        before(:each) do
          resource_class.class_eval do
            def refresh= value
              @data['refresh'] = value.sub /60/, '50'
            end # method refresh=
          end # instance_eval
        end # before each

        it 'should return an instance of the resource' do
          expect(deserialized).to be_a resource_class

          expect(deserialized.refresh).to be == custom_refresh

          permitted_attributes.delete('refresh')
          permitted_attributes.each do |attribute_name|
            expect(deserialized.send attribute_name).to be == attributes[attribute_name]
          end # each
        end # it
      end # describe

      describe 'with a method on the serializer' do
        let(:custom_refresh) { '120Hz' }

        before(:each) do
          instance.define_singleton_method :refresh= do |value|
            resource.refresh = value.gsub /\d+/ do |match|
              2 * match.to_i
            end # sub
          end # method refresh=
        end # before each

        it 'should return an instance of the resource' do
          expect(deserialized).to be_a resource_class

          expect(deserialized.refresh).to be == custom_refresh

          permitted_attributes.delete('refresh')
          permitted_attributes.each do |attribute_name|
            expect(deserialized.send attribute_name).to be == attributes[attribute_name]
          end # each
        end # it
      end # describe
    end # context
  end # describe

  describe '#serialize' do
    include_examples 'with a resource class'

    let(:attributes) { { :width => 640, :height => 480, :refresh => '60Hz', :interlaced => false } }
    let(:resource)   { resource_class.new(*attributes.values) }
    let(:options)    { {} }
    let(:serialized) { instance.serialize resource, **options }
    let(:expected)   { permitted_attributes.each.with_object({}) { |key, hsh| hsh[key] = resource.send key } }

    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    it { expect(serialized).to be == {} }

    context 'with permitted attributes' do
      include_context 'with permitted attributes'

      it 'should return the resource attributes' do
        expect(serialized).to be_a Hash

        expect(serialized.keys).to contain_exactly *permitted_attributes

        permitted_attributes.each do |attribute_name|
          expect(serialized[attribute_name]).to be == expected[attribute_name]
        end # each
      end # it

      describe 'with a method on the object' do
        let(:custom_refresh) { '50Hz' }

        before(:each) { allow(resource).to receive(:refresh).and_return(custom_refresh) }

        it 'should return the resource attributes' do
          expect(serialized).to be_a Hash

          expect(serialized.keys).to contain_exactly *permitted_attributes

          permitted_attributes.each do |attribute_name|
            expect(serialized[attribute_name]).to be == expected[attribute_name]
          end # each
        end # it
      end # describe

      describe 'with a method on the serializer' do
        let(:custom_refresh) { '120Hz' }
        let(:expected)       { super().merge 'refresh' => custom_refresh }

        before(:each) do
          instance.define_singleton_method :refresh do
            resource.refresh.to_s.gsub /\d+/ do |match|
              2 * match.to_i
            end # sub
          end # method refresh
        end # before each

        it 'should return the resource attributes' do
          expect(serialized).to be_a Hash

          expect(serialized.keys).to contain_exactly *permitted_attributes

          permitted_attributes.each do |attribute_name|
            expect(serialized[attribute_name]).to be == expected[attribute_name]
          end # each
        end # it
      end # describe

      describe 'with a timestamp value' do
        let(:permitted_attributes) { super() << 'purchased_at' }
        let(:attributes)           { super().merge :purchased_at => 1.month.ago }
        let(:expected)             { super().merge 'purchased_at' => attributes[:purchased_at].to_i }

        it 'should return the resource attributes' do
          expect(serialized).to be_a Hash

          expect(serialized.keys).to contain_exactly *permitted_attributes

          permitted_attributes.each do |attribute_name|
            expect(serialized[attribute_name]).to be == expected[attribute_name]
          end # each
        end # it
      end # describe
    end # context
  end # describe
end # describe
