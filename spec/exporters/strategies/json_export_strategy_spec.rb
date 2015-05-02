# spec/exporters/strategies/json_export_strategy_spec.rb

require 'rails_helper'

require 'exporters/strategies/json_export_strategy'

RSpec.describe JsonExportStrategy do
  describe '#deserialize' do
    it { expect(described_class).to respond_to(:deserialize).with(1).argument }

    describe 'with nil' do
      it { expect(described_class.deserialize nil).to be nil }
    end # describe

    describe 'with an empty string' do
      it { expect(described_class.deserialize '').to be nil }
    end # describe

    describe 'with an invalid string' do
      it { expect(described_class.deserialize 'malicious').to be nil }
    end # describe

    describe 'with a string containing a JSON object' do
      it { expect(described_class.deserialize '{"foo":"bar"}').to be == { 'foo' => 'bar' } }
    end # describe
  end # describe

  describe '#serialize' do
    it { expect(described_class).to respond_to(:serialize).with(1).argument }

    describe 'with nil' do
      it { expect(described_class.serialize nil).to be == 'null' }
    end # describe

    describe 'with an empty string' do
      it { expect(described_class.serialize '').to be == '""' }
    end # describe

    describe 'with a string' do
      it { expect(described_class.serialize 'Greetings, programs!').to be == '"Greetings, programs!"' }
    end # describe

    describe 'with an array' do
      it { expect(described_class.serialize [1, 2, 3, 4, 5]).to be == '[1,2,3,4,5]' }
    end # describe

    describe 'with a hash' do
      it { expect(described_class.serialize({ :foo => 'bar' })).to be == '{"foo":"bar"}' }
    end # describe
  end # describe
end # describe
