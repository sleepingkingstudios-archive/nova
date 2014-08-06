# spec/models/feature_spec.rb

require 'rails_helper'

RSpec.describe Feature, :type => :model do
  let(:attributes) { FactoryGirl.attributes_for :feature }
  let(:instance)   { described_class.new attributes }

  describe '#directory' do
    it { expect(instance).to have_reader(:directory_id).with(nil) }

    it { expect(instance).to have_reader(:directory).with(nil) }

    context 'with a directory' do
      let(:directory)  { FactoryGirl.build :directory }
      let(:attributes) { super().merge :directory => directory }

      it { expect(instance.directory_id).to be == directory.id }
    end # context
  end # describe

  describe 'validation' do
    it { expect(instance).to be_valid }
  end # describe
end # describe
