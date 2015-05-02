# spec/exporters/strategies/yaml_export_strategy_spec.rb

require 'rails_helper'

require 'exporters/strategies/yaml_export_strategy'

RSpec.describe YamlExportStrategy do
  describe '#deserialize' do
    it { expect(described_class).to respond_to(:deserialize).with(1).argument }

    describe 'with nil' do
      it { expect(described_class.deserialize nil).to be nil }
    end # describe

    describe 'with an empty string' do
      it { expect(described_class.deserialize '').to be nil }
    end # describe

    describe 'with a non-empty string' do
      it { expect(described_class.deserialize 'Greetings, programs!').to be == 'Greetings, programs!' }
    end # describe

    describe 'with a string containing a JSON object' do
      it { expect(described_class.deserialize '{"foo":"bar"}').to be == { 'foo' => 'bar' } }
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

      it { expect(described_class.deserialize string).to be == expected }
    end # describe
  end # describe

  describe '#serialize' do
    it { expect(described_class).to respond_to(:serialize).with(1).argument }

    describe 'with nil' do
      let(:expected) { "--- \n...\n" }

      it { expect(described_class.serialize nil).to be == expected }
    end # describe

    describe 'with an empty string' do
      let(:expected) { "--- ''\n" }

      it { expect(described_class.serialize '').to be == expected }
    end # describe

    describe 'with a string' do
      let(:expected) { "--- Greetings, programs!\n...\n" }

      it { expect(described_class.serialize 'Greetings, programs!').to be == expected }
    end # describe

    describe 'with an array' do
      let(:expected) { "---\n- 1\n- 2\n- 3\n- 4\n- 5\n" }

      it { expect(described_class.serialize [1, 2, 3, 4, 5]).to be == expected }
    end # describe

    describe 'with a hash' do
      let(:expected) { "---\n:foo: bar\n" }

      it { expect(described_class.serialize({ :foo => 'bar' })).to be == expected }
    end # describe
  end # describe
end # describe
