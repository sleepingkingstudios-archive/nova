# spec/helpers/application_helper_spec.rb

require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  describe '#icon' do
    it { expect(instance).to respond_to(:icon).with(1..2).arguments }
  end # describe

  describe '#present' do
    it { expect(instance).to respond_to(:present).with(1).argument }
  end # describe
end # describe
