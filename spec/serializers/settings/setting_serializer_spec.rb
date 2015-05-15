# spec/serializers/settings/setting_serializer_spec.rb

require 'rails_helper'

require 'serializers/settings/setting_serializer'

RSpec.describe SettingSerializer do
  let(:resource_class) { Setting }

  it { expect(described_class).to be_constructible.with(0, :arbitrary, :keywords) }

  describe '::resource_class' do
    it { expect(described_class).to have_reader(:resource_class).with(resource_class) }
  end # describe

  let(:instance_options)  { {} }
  let(:instance)          { described_class.new(**instance_options) }

  describe '#serialize' do
    let(:resource)   { build(:string_setting) }
    let(:options)    { {} }
    let(:serialized) { instance.serialize resource, **options }
    let(:expected)   { { 'options' => resource.options, 'value' => resource.value } }

    it { expect(instance).to respond_to(:serialize).with(1, :relations, :arbitrary, :keywords) }

    it { expect(serialized).to be == expected }
  end # describe
end # describe
