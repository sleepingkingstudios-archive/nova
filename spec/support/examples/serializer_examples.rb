# spec/support/examples/serializer_examples.rb

require 'support/contexts/serializer_contexts'

module Spec
  module Examples
    module SerializerExamples
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      include Decorators::SerializersHelper
      include Spec::Contexts::SerializerContexts

      shared_examples 'should behave like a serializer' do
        it { expect(described_class).to be_constructible.with(0, :arbitrary, :keywords) }

        describe '::resource_class' do
          it { expect(described_class).to have_reader(:resource_class).with(resource_class) }
        end # describe
      end # shared_examples

      shared_examples 'should return an instance of the resource' do |proc|
        let(:attributes)   { attributes_for(resource_class).with_indifferent_access }
        let(:options)      { {} }
        let(:resource)     { instance.deserialize attributes, **options }
        let(:deserialized) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }
        let(:expected)     { attributes.dup }

        it 'should return an instance of the resource' do
          expect(resource).to be_a resource_class

          deserialized.each do |key, value|
            expect(value).to be == expected[key]
          end # each

          expect(deserialized.keys).to include *(attributes.keys - blacklisted_attributes)

          SleepingKingStudios::Tools::ObjectTools.apply self, proc if proc.respond_to?(:call)
        end # it
      end # shared_examples

      shared_examples 'should return the resource attributes' do |proc|
        let(:resource)   { build(resource_class) }
        let(:options)    { {} }
        let(:serialized) { described_class.serialize(resource, **options) }

        it 'should return the resource attributes' do
          expect_to_serialize_attributes(serialized, resource)

          SleepingKingStudios::Tools::ObjectTools.apply self, proc if proc.respond_to?(:call)
        end # it
      end # shared_examples

      def expect_to_serialize_attributes serialized, resource
        expect(serialized).to be_a Hash

        attributes = resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) }

        expect(serialized.keys).to include '_type', *attributes.keys

        expect(serialized.fetch('_type')).to be == resource.class.name

        expected   = serializer_class(resource).serialize(resource)
        attributes = serialized.dup

        blacklisted_attributes.each do |key|
          attributes.delete key
          expected.delete key
        end # each

        expect(attributes).to be == expected
      end # method expect_to_serialize_attributes

      def expect_to_serialize_blog_posts serialized, blog
        expect(serialized).to have_key 'posts'

        posts = serialized.fetch('posts')
        expect(posts).to be_a Array
        expect(posts.count).to be == blog.posts.count

        posts.each.with_index do |serialized, index|
          post = blog.posts[index]

          expect_to_serialize_attributes(serialized, post)
        end # each
      end # method expect_to_serialize_directory_features

      def expect_to_serialize_directory_children serialized, parent, recursive: false, relations: nil
        expect(serialized).to have_key 'directories'

        directories = serialized.fetch('directories')
        expect(directories).to be_a Array
        expect(directories.count).to be == parent.directories.count

        directories.each.with_index do |serialized, index|
          child = parent.children[index]

          expect_to_serialize_attributes(serialized, child)

          if relations == :all
            expect_to_serialize_directory_features(serialized, child)
          else
            expect(serialized['features']).to be_blank
          end # if-else

          if child.directories.blank?
            expect(serialized['directories']).to be_blank
          else
            expect_to_serialize_directory_children(serialized, child, :recursive => recursive, :relations => relations)
          end # if-else
        end # each
      end # method expect_to_serialize_directory_children

      def expect_to_serialize_directory_features serialized, directory
        expect(serialized).to have_key 'features'

        features = serialized.fetch('features')
        expect(features).to be_a Array
        expect(features.count).to be == directory.features.count

        features.each.with_index do |serialized, index|
          feature = directory.features[index]

          expect_to_serialize_attributes(serialized, feature)
        end # each
      end # method expect_to_serialize_directory_features
    end # module
  end # module
end # module
