# spec/models/settings/string_setting_spec.rb

require 'rails_helper'

RSpec.describe StringSetting, :type => :model do
  let(:attributes) { attributes_for(:string_setting) }
  let(:instance)   { described_class.new attributes }

  describe '#validation' do
    it { expect(instance).to be_valid }

    describe 'value must be a String' do
      let(:attributes) { super().merge :value => { :foo => :bar } }

      it { expect(instance).to have_errors.on(:value).with_message('must be a string') }
    end # describe
  end # describe
end # describe
