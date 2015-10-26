# spec/errors/import_error_spec.rb

require 'rails_helper'

require 'errors/import_error'

RSpec.describe Appleseed::ImportError do
  let(:raw)      { "\0\0" }
  let(:format)   { 'json' }
  let(:instance) { described_class.new raw, format }

  describe '#initialize' do
    it { expect(described_class).to construct.with(2).arguments }
  end # describe

  describe '#format' do
    it { expect(instance).to have_reader(:format).with(format) }
  end # describe

  describe '#message' do
    it { expect(instance).to have_reader(:message).with("unable to import object from #{format} string") }
  end # describe

  describe '#raw' do
    it { expect(instance).to have_reader(:raw).with(raw) }
  end # describe
end # describe
