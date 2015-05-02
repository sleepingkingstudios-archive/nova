# spec/exporters/resource_exporter_spec.rb

require 'rails_helper'

require 'exporters/resource_exporter'

RSpec.describe ResourceExporter do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  shared_context 'with defined attributes' do
    before(:each) do
      described_class.attribute :title
    end # before each
  end # shared_context

  let(:concern)         { ResourceExporter }
  let(:resource_class)  { Feature }
  let(:described_class) { concern.new(resource_class) }

  describe described_class::DSL::Attributes do
    describe '::attribute' do
      it { expect(described_class).to respond_to(:attribute).with(1).argument }
    end # describe

    describe '::attributes' do
      it { expect(described_class).to respond_to(:attributes).with(1..9001).arguments }
    end # describe
  end # describe

  describe described_class::DSL::Relations do
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
      before(:each) { described_class::DSL::Relations.send :public, :relates }

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

  describe '::new' do
    it { expect(concern).to respond_to(:new).with(1).argument }
  end # describe

  it { expect(described_class).to be < Exporter }

  it { expect(described_class).to be_constructible.with(0).arguments }

  describe '::instance' do
    it { expect(described_class).to have_reader(:instance).with(be_a described_class) }
  end # describe

  describe '::resource_class' do
    it { expect(described_class).to have_reader(:resource_class).with(resource_class) }

    it { expect(described_class).not_to have_writer(:resource_class=) }
  end # describe

  describe '::deserialize' do
    let(:attributes) { attributes_for(:feature) }

    it { expect(described_class).to respond_to(:deserialize).with(1, :persist).arguments }

    it 'should return an instance of the resource class' do
      resource = described_class.deserialize attributes
      expect(resource).to be_a resource_class

      attributes.each do |attribute, value|
        expect(resource.send attribute).to be == nil
      end # each
    end # it

    context 'with defined attributes' do
      include_context 'with defined attributes'

      it 'should return an instance of the resource class with the provided attributes' do
        resource = described_class.deserialize attributes
        expect(resource).to be_a resource_class

        attributes.each_key do |attribute|
          expect(resource.send attribute).to be == attributes[attribute]
        end # each
      end # it

      it 'should not create the resource' do
        expect { described_class.deserialize attributes }.not_to change(resource_class, :count)
      end # it

      describe 'with persist => true' do
        it 'should create the resource' do
          expect { described_class.deserialize attributes, :persist => true }.to change(resource_class, :count).by(1)
        end # it
      end # describe
    end # context
  end # describe

  describe '::serialize' do
    it { expect(described_class).to respond_to(:serialize).with(1, :relations).arguments }

    let(:resource) { resource_class.new(attributes_for :feature) }

    it 'should return the resource attributes' do
      attributes = described_class.serialize resource

      expect(attributes).to be == { '_type' => resource_class.name }
    end # it

    context 'with defined attributes' do
      include_context 'with defined attributes'

      it 'should return the resource attributes' do
        attributes = described_class.serialize resource
        expect(attributes).to be_a Hash

        attributes_for(:feature).each_key do |attribute|
          expect(resource.send attribute).to be == attributes[attribute.to_s]
        end # each
      end # it
    end # context
  end # describe
end # describe
