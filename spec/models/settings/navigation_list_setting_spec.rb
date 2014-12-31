# spec/models/settings/navigation_list_setting_spec.rb

require 'rails_helper'

RSpec.describe NavigationListSetting, :type => :model do
  let(:attributes) { attributes_for(:navigation_list_setting) }
  let(:instance)   { described_class.new attributes }

  describe '#validation' do
    it { expect(instance).to be_valid }

    describe 'value must be a Hash' do
      let(:attributes) { super().merge :value => 'Second Star to the Right, and Straight On \'till Morning' }

      it { expect(instance).to have_errors.on(:value).with_message('must be a hash') }
    end # describe

    describe 'value labels must be present' do
      let(:attributes) { super().merge :value => { nil => 'weapons/swords/japanese' } }

      it { expect(instance).to have_errors.on(:value).with_message("label can't be blank") }
    end # describe

    describe 'value urls must be present' do
      let(:attributes) { super().merge :value => { 'Potent Potables' => '' } }

      it { expect(instance).to have_errors.on(:value).with_message("url can't be blank") }
    end # describe

    describe 'with :validate_presence => true' do
      let(:attributes) { super().merge :validate_presence => true }

      describe 'value must be present' do
        let(:attributes) { super().merge :value => {} }

        it { expect(instance).to have_errors.on(:value).with_message("can't be blank") }
      end # describe
    end # describe
  end # describe
end # describe
