# spec/forms/settings/navigation_list_setting_form_spec.rb

require 'rails_helper'

RSpec.describe NavigationListSettingForm, :type => :decorator do
  let(:resource) { build(:navigation_list_setting) }
  let(:instance) { described_class.new(resource) }

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  describe '#update' do
    describe 'with list items hash' do
      let(:list_items) do
        { '1' => {
            'label' => 'Igneous Rocks',
            'url'   => '/rocks/igneous/basalt'
          },
          '2' => {
            'label' => 'Sedimentary Rocks',
            'url'   => '/rocks/sedimentary/limestone'
          },
          '0' => {
            'label' => 'Metamorphic Rocks',
            'url'   => '/rocks/metamorphic/slate'
          }
        } # end hash
      end # let
      let(:params) { ActionController::Parameters.new(:setting => { :value => list_items }) }

      it 'updates the value' do
        instance.update params

        expect(resource.value.count).to be == list_items.count

        list_items.each do |(index, hsh)|
          item = resource.value[index.to_i]

          expect(item['label']).to be == hsh['label']
          expect(item['url']).to   be == hsh['url']
        end # each
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
