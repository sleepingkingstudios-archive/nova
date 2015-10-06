# spec/exporters/json_exporter_spec.rb

require 'rails_helper'

require 'exporters/json_exporter'

RSpec.describe JsonExporter do
  describe '#export' do
    it { expect(described_class).to respond_to(:export).with(1).argument.and_keywords(:pretty) }

    describe 'with nil' do
      it { expect(described_class.export nil).to be == 'null' }

      describe 'with :pretty => true' do
        it { expect(described_class.export nil, :pretty => true).to be == 'null' }
      end # describe
    end # describe

    describe 'with an empty string' do
      it { expect(described_class.export '').to be == '""' }

      describe 'with :pretty => true' do
        it { expect(described_class.export '', :pretty => true).to be == '""' }
      end # describe
    end # describe

    describe 'with a string' do
      it { expect(described_class.export 'Greetings, programs!').to be == '"Greetings, programs!"' }

      describe 'with :pretty => true' do
        it { expect(described_class.export 'Greetings, programs!', :pretty => true).to be == '"Greetings, programs!"' }
      end # describe
    end # describe

    describe 'with an array' do
      it { expect(described_class.export [1, 2, 3, 4, 5]).to be == '[1,2,3,4,5]' }

      describe 'with :pretty => true' do
        it { expect(described_class.export [1, 2, 3, 4, 5], :pretty => true).to be == "[\n  1,\n  2,\n  3,\n  4,\n  5\n]" }
      end # describe
    end # describe

    describe 'with a hash' do
      it { expect(described_class.export({ :foo => 'bar' })).to be == '{"foo":"bar"}' }

      describe 'with :pretty => true' do
        it { expect(described_class.export({ :foo => 'bar' }, :pretty => true)).to be == %{{\n  \"foo\": \"bar\"\n}} }
      end # describe
    end # describe
  end # describe

  describe '#import' do
    it { expect(described_class).to respond_to(:import).with(1).argument }

    describe 'with nil' do
      it { expect(described_class.import nil).to be nil }
    end # describe

    describe 'with an empty string' do
      it { expect(described_class.import '').to be nil }
    end # describe

    describe 'with an invalid string' do
      it { expect(described_class.import 'malicious').to be nil }
    end # describe

    describe 'with a string containing a JSON object' do
      it { expect(described_class.import '{"foo":"bar"}').to be == { 'foo' => 'bar' } }
    end # describe
  end # describe
end # describe
