# spec/forms/settings/string_setting_form_spec.rb

require 'rails_helper'

RSpec.describe StringSettingForm, :type => :decorator do
  let(:resource) { build(:string_setting) }
  let(:instance) { described_class.new(resource) }

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  describe '#update' do
    describe 'with value' do
      let(:value)  { 'To strive, to seek, to find, and not to yield.' }
      let(:params) { ActionController::Parameters.new(:setting => { :value => value }) }

      it 'updates the value' do
        expect { instance.update params }.to change(resource, :value).to be == value
      end # it
    end # describe

    describe 'with options hash' do
      let(:options) { { 'validate_presence' => true } }
      let(:params)  { ActionController::Parameters.new(:setting => { :options => options }) }

      it 'updates the options' do
        expect { instance.update params }.to change(resource, :options).to be == options
      end # it
    end # describe
  end # describe
end # describe
