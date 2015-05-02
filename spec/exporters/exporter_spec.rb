# spec/exporters/exporter_spec.rb

require 'rails_helper'

require 'exporters/exporter'

RSpec.describe Exporter do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  let(:instance) { described_class.new }

  describe '::instance' do
    it { expect(described_class).to have_reader(:instance).with(be_a described_class) }
  end # describe

  describe '::deserialize' do
    it { expect(instance).to respond_to(:deserialize).with(1).argument }

    it 'should return the object' do
      expect(instance.deserialize 'Greetings, programs!').to be == 'Greetings, programs!'
    end # it
  end # describe

  describe '::export' do
    it { expect(instance).to respond_to(:export).with(1..2).arguments }

    describe 'with an object' do
      let(:object)   { 'Greetings, programs!' }
      let(:expected) { %{"#{object}"} }

      it { expect(instance.export(object)).to be == expected }

      describe 'with a strategy' do
        let(:expected) { "--- Greetings, programs!\n...\n" }

        it { expect(instance.export(object, :yaml)).to be == expected }
      end # describe

      describe 'with a custom ::serialize method' do
        let(:expected) { %[{"value":"#{object}"}] }

        before(:each) do
          allow(instance).to receive(:serialize) do |object|
            { :value => object }
          end # allow
        end # before each

        it { expect(instance.export(object)).to be == expected }
      end # describe
    end # describe
  end # describe

  describe '::import' do
    it { expect(instance).to respond_to(:import).with(1..2).arguments }

    describe 'with a string' do
      let(:string)   { %{"#{expected}"} }
      let(:expected) { 'Greetings, programs!' }

      it { expect(instance.import(string)).to be == expected }

      describe 'with a strategy' do
        let(:string) { "--- #{expected}\n...\n" }

        it { expect(instance.import(string, :yaml)).to be == expected }
      end # describe

      describe 'with a custom ::deserialize method' do
        let(:string) { %[{"value":"#{expected}"}] }

        before(:each) do
          allow(instance).to receive(:deserialize) do |hash|
            hash['value']
          end # allow
        end # before each

        it { expect(instance.import(string)).to be == expected }
      end # describe
    end # describe
  end # describe

  describe '::serialize' do
    it { expect(instance).to respond_to(:serialize).with(1).argument }

    it 'should return the object' do
      expect(instance.serialize({ :greetings => 'programs' })).to be == { :greetings => 'programs' }
    end # it
  end # describe
end # describe
