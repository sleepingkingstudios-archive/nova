# spec/models/setting_spec.rb

require 'rails_helper'

RSpec.describe Setting, :type => :model do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  shared_context 'with many settings' do
    let(:settings_hash) do
      { 'ace.title'      => 'Baron',
        'ace.first_name' => 'Manfred',
        'ace.last_name'  => 'von Richthofen'
      } # end hash
    end # let
    let!(:settings) do
      settings_hash.map do |key, value|
        create(:string_setting, :key => key, :value => value)
      end # each
    end # let!
  end # context

  let(:attributes) { attributes_for(:setting) }
  let(:instance)   { described_class.new attributes }

  ### Class Methods ###

  describe '::fetch' do
    it { expect(described_class).to respond_to(:fetch).with(1..2).arguments }

    it 'raises an error' do
      expect {
        described_class.fetch 'namespaced.key'
      }.to raise_error KeyError, 'key not found: "namespaced.key"'
    end # it

    describe 'with a default value' do
      it { expect(described_class.fetch 'namespaced.key', 'default').to be == 'default' }
    end # describe

    context 'with many settings' do
      include_context 'with many settings'

      it { expect(described_class.fetch settings_hash.keys.first).to be == settings_hash.values.first }

      describe 'with a default value' do
        it { expect(described_class.fetch settings_hash.keys.first, 'default').to be == settings_hash.values.first }
      end # describe
    end # context
  end # describe

  describe '::fetch_with_i18n_fallback' do
    it { expect(described_class).to respond_to(:fetch_with_i18n_fallback).with(1..2).arguments }

    it 'raises an error' do
      expect {
        described_class.fetch_with_i18n_fallback 'namespaced.key'
      }.to raise_error KeyError, 'key not found: "namespaced.key"'
    end # it

    describe 'with a default value' do
      it { expect(described_class.fetch_with_i18n_fallback 'namespaced.key', 'default').to be == 'default' }
    end # describe

    context 'with an i18n translation' do
      before(:each) { allow(I18n).to receive(:translate).and_return('translated') }

      it 'falls back to i18n' do
        expect(described_class.fetch_with_i18n_fallback 'namespaced.key').to be == 'translated'
      end # it

      describe 'with a default value' do
        it { expect(described_class.fetch_with_i18n_fallback 'namespaced.key', 'default').to be == 'translated' }
      end # describe
    end # describe

    context 'with many settings' do
      include_context 'with many settings'

      it { expect(described_class.fetch_with_i18n_fallback settings_hash.keys.first).to be == settings_hash.values.first }

      describe 'with a default value' do
        it { expect(described_class.fetch_with_i18n_fallback settings_hash.keys.first, 'default').to be == settings_hash.values.first }
      end # describe

      context 'with an i18n translation' do
        before(:each) { allow(I18n).to receive(:translate).and_return('translated') }

        it 'falls back to i18n' do
          expect(described_class.fetch_with_i18n_fallback settings_hash.keys.first).to be == settings_hash.values.first
        end # it
      end # context
    end # context
  end # describe

  describe '::get' do
    it { expect(described_class).to respond_to(:get).with(1).argument }

    it { expect(described_class.get 'namespaced.key').to be nil }

    context 'with many settings' do
      include_context 'with many settings'

      it { expect(described_class.get settings_hash.keys.first).to be == settings_hash.values.first }
    end # context
  end # describe

  ### Attributes ###

  describe '#key' do
    it { expect(instance).to have_property(:key).with_value(attributes.fetch(:key)) }
  end # describe

  describe '#options' do
    it { expect(instance).to have_property(:options).with_value({}) }
  end # describe

  describe '#value' do
    it { expect(instance).to have_reader(:value).with_value(nil) }
  end # describe

  ### Validation ###

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'key must be present' do
      let(:attributes) { super().merge :key => nil }

      it { expect(instance).to have_errors.on(:key).with_message("can't be blank") }
    end # describe

    describe 'key must be unique' do
      before(:each) { create(:setting, :key => attributes[:key]) }

      it { expect(instance).to have_errors.on(:key).with_message("is already taken") }
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#validate_presence?' do
    it { expect(instance).to have_reader(:validate_presence?).with_value(false) }

    describe 'with :validate_presence => true' do
      let(:attributes) { super().merge :options => (super()[:options] || {}).merge(:validate_presence => true) }

      it { expect(instance.validate_presence?).to be true }
    end # describe
  end # describe
end # describe
