  # spec/forms/settings/navigation_list_setting_form_spec.rb

require 'rails_helper'

RSpec.describe NavigationListSettingForm, :type => :decorator do
  let(:attributes) { {} }
  let(:resource)   { build(:navigation_list_setting, attributes) }
  let(:instance)   { described_class.new(resource) }

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  describe '#update_attributes' do
    let(:attributes) { attributes_for(:navigation_list_setting, :with_a_list) }
    let(:resource)   { super().tap &:save! }

    describe 'with an invalid list items hash' do
      let(:list_items) do
        { '1' => {
            'label' => '',
            'url'   => '/rocks/igneous/basalt'
          }, # end hash
          '2' => {
            'label' => 'Sedimentary Rocks',
            'url'   => ''
          }, # end hash
          '0' => {
            'label' => 'Metamorphic Rocks',
            'url'   => '/rocks/metamorphic/slate'
          } # end hash
        } # end hash
      end # let
      let(:params) { ActionController::Parameters.new(:setting => { :value => list_items }) }

      it 'does not update the value' do
        expect { instance.update params }.not_to change { resource.reload.value }
      end # it
    end # describe

    describe 'with a valid list items hash' do
      let(:list_items) do
        { '1' => {
            'label' => 'Igneous Rocks',
            'url'   => '/rocks/igneous/basalt'
          }, # end hash
          '2' => {
            'label' => 'Sedimentary Rocks',
            'url'   => '/rocks/sedimentary/limestone'
          }, # end hash
          '0' => {
            'label' => 'Metamorphic Rocks',
            'url'   => '/rocks/metamorphic/slate'
          } # end hash
        } # end hash
      end # let
      let(:params) { ActionController::Parameters.new(:setting => { :value => list_items }) }

      it 'updates the value' do
        instance.update params

        resource.reload

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
