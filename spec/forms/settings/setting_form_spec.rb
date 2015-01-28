# spec/forms/settings/setting_form_spec.rb

require 'rails_helper'

RSpec.describe SettingForm, :type => :decorator do
  let(:resource) { build(:setting) }
  let(:instance) { described_class.new resource }

  describe '#resource_key' do
    it { expect(instance).to have_reader(:resource_key).with_value('setting') }
  end # describe

  describe '#update' do
    describe 'with options hash' do
      let(:options) { { 'validate_presence' => true } }
      let(:params)  { ActionController::Parameters.new(:setting => { :options => options }) }

      it 'updates the options' do
        expect { instance.update params }.to change(resource, :options).to be == options
      end # it
    end # describe
  end # describe
end # describe
