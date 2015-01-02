# spec/models/settings/navigation_list_spec.rb

require 'rails_helper'

RSpec.describe NavigationList, :type => :model do
  shared_context 'with a setting' do
    let(:setting_attributes) { attributes_for(:setting) }
    let!(:setting)           { build(:navigation_list_setting, setting_attributes) }

    before(:each) { instance.container = setting }
  end # shared_context

  shared_context 'with many items' do
    let!(:items) do
      Array.new(3).map { build(:navigation_list_item, :list => instance) }
    end # let!
  end # shared_context

  let(:attributes) { attributes_for(:navigation_list) }
  let(:instance)   { described_class.new(attributes) }

  ### Relations ###

  describe '#items' do
    it { expect(instance).to have_reader(:items).with_value([]) }

    context 'with many items' do
      include_context 'with many items'

      it { expect(instance.items).to contain_exactly *items }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    context 'with a setting' do
      include_context 'with a setting'

      it { expect(instance).to be_valid }
    end # context

    describe 'container must be present' do
      let(:attributes) { super().merge :container => nil }

      it { expect(instance).to have_errors.on(:container).with_message("can't be blank") }
    end # describe

    context 'with a setting' do
      include_context 'with a setting'

      context 'with validate_presence => true' do
        let(:setting_attributes) { super().merge :options => ((super()[:options] || {}).merge :validate_presence => true) }

        describe 'items must be present' do
          it { expect(instance).to have_errors.on(:items).with_message("can't be blank") }
        end # describe
      end # context
    end # context
  end # describe

  ### Instance Methods ###

  describe '#options' do
    it { expect(instance).to have_reader(:options).with_value({}) }

    context 'with a setting' do
      include_context 'with a setting'

      context 'with validate_presence => true' do
        let(:setting_attributes) { super().merge :options => ((super()[:options] || {}).merge :validate_presence => true) }

        it { expect(instance).to have_reader(:options).with_value(:validate_presence => true) }
      end # context
    end # context
  end # describe

  describe '#validate_presence?' do
    it { expect(instance).to have_reader(:validate_presence?).with_value(false) }

    context 'with a setting' do
      include_context 'with a setting'

      it { expect(instance.validate_presence?).to be false }

      context 'with validate_presence => true' do
        let(:setting_attributes) { super().merge :options => ((super()[:options] || {}).merge :validate_presence => true) }

        it { expect(instance.validate_presence?).to be true }
      end # context
    end # context
  end # describe

  describe '#value' do
    it { expect(instance).to have_reader(:value).with_value([]) }

    context 'with many items' do
      include_context 'with many items'

      it { expect(instance.value).to be == items.map(&:value) }
    end # context
  end # describe
end # describe
