# spec/helpers/exporters_helper_spec.rb

require 'rails_helper'

RSpec.describe ExportersHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  describe '#export' do
    it { expect(instance).to respond_to(:export).with(1).argument.and_keywords(:format).and_arbitrary_keywords }

    describe 'with a Hash' do
      let(:hsh) { { 'foo' => 'bar' } }

      it 'should serialize the hash as JSON' do
        expect(instance.export hsh, :format => :json).to be == "{\"foo\":\"bar\"}"
      end # it

      it 'should serialize the hash as YAML' do
        expect(instance.export hsh, :format => :yaml).to be == "---\nfoo: bar\n"
      end # it
    end # describe

    describe 'with a serializable object' do
      let(:obj) { build(:feature) }

      it 'should serialize the object as JSON' do
        str = instance.export(obj, :format => :json)
        hsh = JSON.parse(str)

        expect(hsh.fetch('title')).to be == obj.title
        expect(hsh.fetch('_type')).to be == obj.class.name
      end # it

      it 'should serialize the object as YAML' do
        str = instance.export(obj, :format => :yaml)
        hsh = YAML.load str

        expect(hsh.fetch('title')).to be == obj.title
        expect(hsh.fetch('_type')).to be == obj.class.name
      end # it
    end # describe

    describe 'with an unserializable object' do
      let(:obj) { Struct.new(:catchphrase) { def self.name; 'Catchphrase'; end }.new('No way, José!') }

      it 'should raise an error' do
        expect { instance.export(obj, :format => :json) }.to raise_error StandardError, 'undefined serializer for type Catchphrase'
      end # it
    end # describe
  end # describe

  describe '#import' do
    it { expect(instance).to respond_to(:export).with(1).argument.and_keywords(:format, :type).and_arbitrary_keywords }

    describe 'with an object serialized as JSON' do
      let(:hsh) { serialize(build(:feature)) }
      let(:str) { hsh.to_json }
      let(:obj) { instance.import str, :format => :json }

      it 'should return the object' do
        expect(obj.title).to be == hsh['title']
        expect(obj.class.name).to be == hsh['_type']
      end # it

      it 'should not create a document' do
        expect { instance.import str, :format => :json }.not_to change(Feature, :count)
      end # it

      describe 'with :persist => true' do
        it 'should create a document' do
          expect { instance.import str, :format => :json, :persist => true }.to change(Feature, :count).by(1)
        end # it
      end # it
    end # describe

    describe 'with an object serialized as YAML' do
      let(:hsh) { serialize(build(:feature)) }
      let(:str) { YAML.dump hsh }
      let(:obj) { instance.import str, :format => :yaml }

      it 'should return the object' do
        expect(obj.title).to be == hsh['title']
        expect(obj.class.name).to be == hsh['_type']
      end # it

      it 'should not create a document' do
        expect { instance.import str, :format => :yaml }.not_to change(Feature, :count)
      end # it

      describe 'with :persist => true' do
        it 'should create a document' do
          expect { instance.import str, :format => :yaml, :persist => true }.to change(Feature, :count).by(1)
        end # it
      end # it
    end # describe
  end # describe
end # describe