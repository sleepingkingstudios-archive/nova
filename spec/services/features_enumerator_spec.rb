# spec/services/features_enumerator_spec.rb

require 'rails_helper'

require 'services/features_enumerator'

RSpec.describe FeaturesEnumerator, :type => :service do
  let(:instance) { Object.new.extend described_class }

  describe '#each' do
    it { expect(instance).to respond_to(:each).with(0..9001).arguments.with_a_block }
  end # describe

  describe '#feature' do
    around(:each) do |example|
      memoized_value = described_class.instance_variable_get(:@features).dup

      example.run

      described_class.instance_variable_set :@features, memoized_value
    end # around

    it { expect(instance).to respond_to(:feature).with(1..2).arguments }

    describe 'with a model name' do
      let(:model_name)  { :example_feature }
      let(:model_class) { "ExampleFeature" }
      let(:scope_name)  { model_name.to_s.pluralize }
      let(:options) do
        { :class  => model_class,
          :parent => :directory
        } # end hash
      end # let

      around(:each) do |example|
        Object.const_set(:ExampleFeature, Spec::Models::ExampleFeature)

        example.run

        Object.send :remove_const, :ExampleFeature
      end # around

      it 'appends the plural name and options to ::features' do
        expect {
          instance.feature(model_name)
        }.to change(instance, :features).to include(scope_name => options)
      end # it

      it 'registers the feature with Directory' do
        expect(Directory).to receive(:feature).with(model_name, options)

        instance.feature model_name
      end # it
    end # describe

    describe 'with a model name and class' do
      let(:model_name)  { :example_feature }
      let(:model_class) { "Spec::Models::#{model_name.to_s.camelize}" }
      let(:scope_name)  { model_name.to_s.pluralize }
      let(:options) do
        { :class  => model_class,
          :parent => :directory
        } # end hash
      end # let

      it 'appends the plural name and options to ::features' do
        expect {
          instance.feature(model_name, :class => model_class)
        }.to change(instance, :features).to include(scope_name => options)
      end # it

      it 'registers the feature with Directory' do
        expect(Directory).to receive(:feature).with(model_name, options)

        instance.feature(model_name, options)
      end # it
    end # describe

    describe 'with a model name and options' do
      let(:model_name)  { :example_feature }
      let(:model_class) { "Spec::Models::#{model_name.to_s.camelize}" }
      let(:scope_name)  { model_name.to_s.pluralize }
      let(:options) do
        { :class  => model_class,
          :parent => :blog
        } # end hash
      end # let

      it 'appends the plural name and options to ::features' do
        expect {
          instance.feature(model_name, :class => model_class, :parent => :blog)
        }.to change(instance, :features).to include(scope_name => options)
      end # it

      it 'registers the feature with Directory' do
        expect(Directory).to receive(:feature).with(model_name, options)

        instance.feature(model_name, options)
      end # it
    end # describe
  end # describe

  describe '#features' do
    it { expect(instance).to have_reader(:features) }

    it 'is immutable' do
      expect { instance.features['autodefenestrate'] = "Autodefenestrate" }.not_to change(described_class, :features)
    end # it
  end # describe
end # describe
