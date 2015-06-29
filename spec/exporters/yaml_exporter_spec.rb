# spec/exporters/yaml_exporter_spec.rb

require 'rails_helper'

require 'exporters/yaml_exporter'

RSpec.describe YamlExporter do
  describe '#export' do
    it { expect(described_class).to respond_to(:export).with(1).argument }

    describe 'with nil' do
      let(:expected) { "--- \n...\n" }

      it { expect(described_class.export nil).to be == expected }
    end # describe

    describe 'with an empty string' do
      let(:expected) { "--- ''\n" }

      it { expect(described_class.export '').to be == expected }
    end # describe

    describe 'with a string' do
      let(:expected) { "--- Greetings, programs!\n...\n" }

      it { expect(described_class.export 'Greetings, programs!').to be == expected }
    end # describe

    describe 'with an array' do
      let(:expected) { "---\n- 1\n- 2\n- 3\n- 4\n- 5\n" }

      it { expect(described_class.export [1, 2, 3, 4, 5]).to be == expected }
    end # describe

    describe 'with a hash' do
      let(:expected) { "---\n:foo: bar\n" }

      it { expect(described_class.export({ :foo => 'bar' })).to be == expected }
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

    describe 'with a non-empty string' do
      it { expect(described_class.import 'Greetings, programs!').to be == 'Greetings, programs!' }
    end # describe

    describe 'with a string containing a JSON object' do
      it { expect(described_class.import '{"foo":"bar"}').to be == { 'foo' => 'bar' } }
    end # describe

    describe 'with a string containing a YAML document' do
      let(:string) do
        <<-YAML.split("\n").map { |s| s[10..-1] }.join("\n")
          ---
          weapons:
            swords:
              japanese:
              - daito
              - shoto
        YAML
      end # let
      let(:expected) do
        { 'weapons' => { 'swords' => { 'japanese' => ['daito', 'shoto'] } } }
      end # let

      it { expect(described_class.import string).to be == expected }
    end # describe
  end # describe
end # describe
