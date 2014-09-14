# spec/models/example_feature_spec.rb

require 'rails_helper'

RSpec.describe Spec::Models::ExampleFeature, :type => :model do
  let(:attributes) { attributes_for(:example_feature) }
  let(:instance)   { described_class.new attributes }

  describe '#directory' do
    it { expect(instance).to have_reader(:directory_id).with(nil) }

    it { expect(instance).to have_reader(:directory).with(nil) }

    context 'with a directory' do
      let(:directory)  { build :directory }
      let(:attributes) { super().merge :directory => directory }

      it { expect(instance.directory_id).to be == directory.id }
    end # context
  end # describe

  describe '#example_field' do
    it { expect(instance).to have_property(:example_field) }
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'example_field must be present' do
      let(:attributes) { super().merge :example_field => nil }

      it { expect(instance).to have_errors.on('example_field').with_message("can't be blank") }
    end # describe
  end # describe
end # describe
