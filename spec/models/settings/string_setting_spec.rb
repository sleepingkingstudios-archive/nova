# spec/models/settings/string_setting_spec.rb

require 'rails_helper'

RSpec.describe StringSetting, :type => :model do
  let(:attributes) { attributes_for(:string_setting) }
  let(:instance)   { described_class.new attributes }

  ### Attributes ###

  describe '#value' do
    it { expect(instance).to have_property(:value).with_value(attributes[:value]) }
  end # describe

  ### Validation ###

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'with :validate_presence => true' do
      let(:attributes) { super().merge :options => (super()[:options] || {}).merge(:validate_presence => true) }

      describe 'value must be present' do
        let(:attributes) { super().merge :value => nil }

        it { expect(instance).to have_errors.on(:value).with_message("can't be blank") }
      end # describe
    end # describe
  end # describe
end # describe
