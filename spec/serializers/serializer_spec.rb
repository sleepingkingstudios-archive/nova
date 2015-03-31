# spec/serializers/serializer_spec.rb

require 'rails_helper'

RSpec.describe Serializer, :type => :decorator do
  let(:object)   { double('object') }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  describe '#to_json' do
    it { expect(instance).to respond_to(:to_json).with(0).arguments }

    it { expect(instance.to_json).to be == {} }

    describe 'with whitelisted attributes' do
      let(:attributes) { %w(foo bar) }
      let(:object)     { double('object', :foo => 'foo', :bar => 'bar' )}
      let(:json)       { instance.to_json }

      before(:each) { allow(instance).to receive(:attributes).and_return(attributes) }

      it 'serializes the whitelisted attributes' do
        expect(json.keys).to be == attributes

        attributes.each do |attribute|
          expect(json.fetch attribute).to be == object.send(attribute)
        end # each
      end # it
    end # describe
  end # describe
end # describe
