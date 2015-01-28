# spec/serializers/settings/setting_serializer_spec.rb

require 'rails_helper'

RSpec.describe SettingSerializer, :type => :decorator do
  let(:setting)  { create(:string_setting) }
  let(:instance) { described_class.new setting }

  describe '#to_json' do
    let(:json) { { 'options' => setting.options, 'value' => setting.value } }

    it { expect(instance).to respond_to(:to_json).with(0).arguments }

    it { expect(instance.to_json).to be == json }
  end # describe
end # describe
