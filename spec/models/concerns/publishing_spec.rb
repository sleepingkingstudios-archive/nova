# spec/models/concerns/publishing_spec.rb

require 'rails_helper'

RSpec.describe Publishing do
  let(:described_class) do
    klass = Class.new
    klass.send :include, Mongoid::Document
    klass.send :include, super()
    klass
  end # let
  let(:instance) { described_class.new }

  before(:each) { allow(Time).to receive(:current).and_return(0.days.ago) }

  describe '::published' do
    let(:criteria) { described_class.published }

    it { expect(described_class).to respond_to(:published).with(0).arguments }

    it { expect(described_class.published).to be_a Mongoid::Criteria }

    it { expect(criteria.selector['published_at']).to be == { '$lt' => Time.current } }
  end # describe

  describe '#publish' do
    it { expect(instance).to respond_to(:publish).with(0).arguments }

    it 'sets the #published_at value' do
      expect { instance.publish }.to change(instance, :published_at).to be_a ActiveSupport::TimeWithZone
    end # it
  end # describe

  describe '#published_at' do
    it { expect(instance).to have_reader(:published_at).with_value(nil) }
  end # describe

  describe '#published_at=' do
    let(:value) { 1.day.ago }

    it { expect(instance).to have_writer(:published_at=) }

    it 'changes the value' do
      expect { instance.published_at = value }.to change(instance, :published_at).to(value)
    end # it
  end # describe

  describe '#published?' do
    it { expect(instance).to have_reader(:published?).with_value(false) }

    context 'with a published date in the past' do
      before(:each) { instance.published_at = 1.day.ago }

      it { expect(instance.published?).to be true }
    end # context

    context 'with a published date in the future' do
      before(:each) { instance.published_at = 1.day.from_now }

      it { expect(instance.published?).to be false }
    end # context
  end # describe
end # describe
