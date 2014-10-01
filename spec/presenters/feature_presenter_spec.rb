# spec/presenters/feature_presenter_spec.rb

require 'rails_helper'

require 'presenters/feature_presenter'

RSpec.describe FeaturePresenter, :type => :decorator do
  let(:feature)  { build(:feature) }
  let(:instance) { described_class.new feature }

  describe '#feature' do
    it { expect(instance).to have_reader(:feature).with(feature) }
  end # describe

  describe '#icon' do
    let(:expected) { %{<span class="fa fa-cube"></span>} }

    it { expect(instance).to respond_to(:icon).with(0..1).arguments }

    it { expect(instance.icon).to be == expected }

    describe 'with options' do
      let(:expected) { %{<span class="fa fa-cube fa-2x"></span>} }

      it { expect(instance.icon :scale => 2).to be == expected }      
    end # describe
  end # describe

  describe '#label' do
    it { expect(instance).to have_reader(:label).with(feature.title) }

    context 'with a changed title' do
      before(:each) do
        feature.save!
        feature.title = attributes_for(:feature).fetch(:title)
      end # before each

      it { expect(instance.label).to be == feature.title_was }
    end # context
  end # describe

  describe '#slug' do
    it { expect(instance).to have_reader(:slug).with(feature.slug) }
  end # describe

  describe '#title' do
    it { expect(instance).to have_reader(:title).with(feature.title) }
  end # describe

  describe '#type' do
    it { expect(instance).to have_reader(:type).with(feature._type) }
  end # describe
end # describe
