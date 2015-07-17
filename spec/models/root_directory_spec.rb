# spec/models/root_directory_spec.rb

require 'rails_helper'

RSpec.describe RootDirectory do
  let(:instance) { described_class.instance }

  describe '::instance' do
    it { expect(described_class).to have_reader(:instance).with_value(an_instance_of described_class) }

    it 'should be idempotent' do
      expect(described_class.instance).to be instance
    end # it
  end # describe

  describe '::name' do
    it { expect(described_class).to have_reader(:name).with_value('Directory') }
  end # describe

  describe '::new' do
    it { expect(described_class).not_to respond_to(:new) }
  end # describe

  describe '#blank?' do
    it { expect(instance).to have_reader(:blank?).with_value(true) }
  end # describe

  describe '#[]' do
    it { expect(instance).to respond_to(:[]).with(1).argument }

    it { expect(instance[:arbitrary]).to be nil }
  end # describe

  describe '#attributes' do
    it { expect(instance).to have_reader(:attributes).with_value(be == {}) }
  end # describe

  describe '#children' do
    it { expect(instance).to have_reader(:children).with_value(an_instance_of Mongoid::Criteria) }

    it { expect(instance).to have_reader(:directories).with_value(an_instance_of Mongoid::Criteria) }

    it { expect(instance.children).to be == [] }

    context 'with many directories' do
      let!(:children)      { Array.new(3) { create(:directory) } }
      let!(:grandchildren) { Array.new(3) { create(:directory, :parent => children.first) } }

      it { expect(instance.children).to contain_exactly(*children) }
    end # context
  end # describe

  describe '#features' do
    it { expect(instance).to have_reader(:features).with_value(an_instance_of Mongoid::Criteria) }

    it { expect(instance.features).to be == [] }

    context 'with many features' do
      let!(:features)           { Array.new(3) { create(:feature) } }
      let!(:root_features)      { Array.new(3) { create(:directory_feature) } }
      let!(:directory)          { create(:directory) }
      let!(:directory_features) { Array.new(3) { create(:directory_feature, :directory => directory) } }

      it { expect(instance.features).to contain_exactly(*root_features) }
    end # context
  end # describe

  describe '#parent' do
    it { expect(instance).to have_reader(:parent).with_value(nil) }
  end # describe
end # describe
