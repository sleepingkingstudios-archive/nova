# spec/serializers/features/directory_feature_serializer_spec.rb

require 'rails_helper'

require 'serializers/features/directory_feature_serializer'

RSpec.describe DirectoryFeatureSerializer do
  include Spec::Contexts::SerializerContexts
  include Spec::Examples::SerializerExamples

  include_context 'with a serializer for', DirectoryFeature

  include_examples 'should behave like a serializer'

  before(:each) { blacklisted_attributes << 'directory' << 'directory_id' }

  describe '#deserialize' do
    before(:each) { expected.merge! 'slug' => attributes[:title].parameterize, 'slug_lock' => false }

    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return an instance of the resource'

    describe 'with a valid directory' do
      let(:directory) { create(:directory) }

      before(:each) { attributes[:directory] = directory.to_partial_path }

      include_examples 'should return an instance of the resource', ->() {
        expect(resource.directory).to be == directory
      } # end examples

      context 'with many ancestors' do
        let(:ancestors) { ary = Array.new(3).tap { |ary| ary.each_index { |index| ary[index] = create(:directory, :parent => ary[index - 1]) } } }
        let(:directory) { create(:directory, :parent => ancestors.last) }

        include_examples 'should return an instance of the resource', ->() {
          expect(resource.directory).to be == directory
        } # end examples
      end # context
    end # describe

    describe 'with an invalid directory' do
      before(:each) { attributes[:directory] = 'not/a/directory' }

      it 'should raise an error' do
        expect { instance.deserialize attributes }.to raise_error Directory::NotFoundError
      end # it

      it 'should not create a feature' do
        expect { begin; instance.deserialize attributes; rescue Directory::NotFoundError; end }.not_to change(DirectoryFeature, :count)
      end # it
    end # describe
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return the resource attributes'

    context 'with a directory' do
      let(:directory) { create(:directory) }

      before(:each) { resource.directory = directory }

      include_examples 'should return the resource attributes', ->() {
        expect(serialized).to have_key 'directory'
        expect(serialized['directory']).to be == directory.to_partial_path
      } # end examples

      context 'with many ancestors' do
        let(:ancestors) { ary = Array.new(3).tap { |ary| ary.each_index { |index| ary[index] = create(:directory, :parent => ary[index - 1]) } } }
        let(:directory) { create(:directory, :parent => ancestors.last) }

        include_examples 'should return the resource attributes', ->() {
          expect(serialized).to have_key 'directory'
          expect(serialized['directory']).to be == directory.to_partial_path
        } # end examples
      end # context
    end # context
  end # describe
end # describe
