# spec/models/setting_spec.rb

require 'rails_helper'

RSpec.describe Setting, :type => :model do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  let(:attributes) { attributes_for(:setting) }
  let(:instance)   { described_class.new attributes }

  ### Attributes ###

  describe '#key' do
    it { expect(instance).to have_property(:key).with_value(attributes.fetch(:key)) }
  end # describe

  describe '#value' do
    it { expect(instance).to have_property(:value) }
  end # describe

  describe '#validate_presence' do
    it { expect(instance).to have_property(:validate_presence) }
  end # describe

  ### Validation ###

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'key must be present' do
      let(:attributes) { super().merge :key => nil }

      it { expect(instance).to have_errors.on(:key).with_message("can't be blank") }
    end # describe

    describe 'key must be unique' do
      before(:each) { create(:setting, :key => attributes[:key]) }

      it { expect(instance).to have_errors.on(:key).with_message("is already taken") }
    end # describe

    describe 'with :validate_presence => true' do
      let(:attributes) { super().merge :validate_presence => true }

      describe 'value must be present' do
        let(:attributes) { super().merge :value => nil }

        it { expect(instance).to have_errors.on(:value).with_message("can't be blank") }
      end # describe
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#validate_presence?' do
    it { expect(instance).to have_reader(:validate_presence?).with_value(false) }

    describe 'with :validate_presence => true' do
      let(:attributes) { super().merge :validate_presence => true }

      it { expect(instance.validate_presence?).to be true }
    end # describe
  end # describe
end # describe
