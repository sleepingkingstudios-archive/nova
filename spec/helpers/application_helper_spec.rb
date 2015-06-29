# spec/helpers/application_helper_spec.rb

require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  describe '#deserialize' do
    it { expect(instance).to respond_to(:deserialize).with(1).argument }
  end # describe

  describe '#export' do
    it { expect(instance).to respond_to(:export).with(1).argument.and_keywords(:format).and_arbitrary_keywords }
  end # describe

  describe '#icon' do
    it { expect(instance).to respond_to(:icon).with(1..2).arguments }
  end # describe

  describe '#import' do
    it { expect(instance).to respond_to(:import).with(1).argument.and_keywords(:format, :type).and_arbitrary_keywords }
  end # describe

  describe '#present' do
    it { expect(instance).to respond_to(:present).with(1).argument }
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1).argument }
  end # describe
end # describe
