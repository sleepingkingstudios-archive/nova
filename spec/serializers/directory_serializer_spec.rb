# spec/serializers/directory_serializer_spec.rb

require 'rails_helper'

require 'serializers/directory_serializer'

RSpec.describe DirectorySerializer do
  include Spec::Contexts::SerializerContexts
  include Spec::Examples::SerializerExamples

  include_context 'with a serializer for', Directory

  before(:each) { blacklisted_attributes << 'directories' << 'features' }

  describe '#deserialize' do
    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return an instance of the resource'

    describe 'with attributes for many descendant directories' do
      let(:children_attributes)      { Array.new(3) { attributes_for(:directory, :_type => 'Directory') } }

      let(:grandchildren_attributes) { Array.new(3) { attributes_for(:directory, :_type => 'Directory') } }

      before(:each) do
        attributes['directories'] = children_attributes
        attributes['directories'][0]['directories'] = grandchildren_attributes
      end

      include_examples 'should return an instance of the resource', ->() {
        directories = resource.directories.to_a
        expect(directories.count).to be == children_attributes.count
        expect(directories.map &:title).to contain_exactly *children_attributes.map { |hsh| hsh[:title] }

        directories = resource.directories.first.directories.to_a
        expect(directories.count).to be == grandchildren_attributes.count
        expect(directories.map &:title).to contain_exactly *grandchildren_attributes.map { |hsh| hsh[:title] }
      } # end examples

      describe 'with attributes for many features' do
        before(:each) do
          [attributes, *children_attributes, *grandchildren_attributes].each do |hsh|
            hsh['features'] = []
            3.times do
              hsh['features'] << attributes_for(:page,
                :_type   => 'Page',
                :content => attributes_for(:content, :_type => 'Content')
              ) # end attributes
            end # times
          end # each
        end # before each

        include_examples 'should return an instance of the resource', ->() {
          directories = resource.directories.to_a
          expect(directories.count).to be == children_attributes.count
          expect(directories.map &:title).to contain_exactly *children_attributes.map { |hsh| hsh[:title] }

          directories.each do |directory|
            expect(directory.features.to_a.count).to be == 3
          end # each

          directories = resource.directories.first.directories.to_a
          expect(directories.count).to be == grandchildren_attributes.count
          expect(directories.map &:title).to contain_exactly *grandchildren_attributes.map { |hsh| hsh[:title] }

          directories.each do |directory|
            expect(directory.features.to_a.count).to be == 3
          end # each
        } # end examples
      end # describe
    end # describe

    describe 'with attributes for many features' do
      let(:pages_attributes) do
        Array.new(3) do
          attributes_for(:page,
            :_type   => 'Page',
            :content => attributes_for(:content, :_type => 'Content')
          ) # end attributes
        end # array
      end # let

      before(:each) { attributes['features'] = pages_attributes }

      include_examples 'should return an instance of the resource', ->() {
        features = resource.features.to_a
        expect(features.count).to be == pages_attributes.count
        expect(features.map &:title).to contain_exactly *pages_attributes.map { |hsh| hsh[:title] }
      } # end examples
    end # describe
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return the resource attributes', ->() {
      expect(serialized['directories']).to be_blank
    } # end examples

    describe 'with many features' do
      let(:pages) { Array.new(3) { create(:page, :content => build(:content), :directory => resource ) } }

      before(:each) { pages.each { |page| resource.features << page } }

      include_examples 'should return the resource attributes', ->() {
        expect(serialized['features']).to be_blank
      } # end examples

      describe 'with :relations => :all' do
        before(:each) { options[:relations] = :all }

        include_examples 'should return the resource attributes', ->() {
          expect(serialized).to have_key 'features'

          features = serialized.fetch('features')
          expect(features).to be_a Array
          expect(features.count).to be == resource.features.count

          resource.features.each do |page|
            expect(features).to include PageSerializer.serialize(page)
          end # each
        } # end examples
      end # describe
    end # describe

    describe 'with many descendant directories' do
      let(:children)      { Array.new(3) { create(:directory, :parent => resource) } }
      let(:grandchildren) { Array.new(3) { create(:directory, :parent => children.first) } }

      before(:each) do
        resource.save!

        children.each { |directory| resource.children << directory }

        grandchildren.each { |directory| children.first.children << directory }
      end # before each

      include_examples 'should return the resource attributes', ->() {
        expect(serialized['directories']).to be_blank
      } # end examples

      describe 'with :recursive => true' do
        before(:each) { options[:recursive] = true }

        include_examples 'should return the resource attributes', ->() {
          expect(serialized).to have_key 'directories'

          directories = serialized.fetch('directories')
          expect(directories).to be_a Array
          expect(directories.count).to be == children.count

          children.each do |directory|
            expect(directories).to include DirectorySerializer.serialize(directory, **options)
          end # each

          expect(directories.first).to have_key 'directories'

          directories = directories.first.fetch('directories')
          expect(directories).to be_a Array
          expect(directories.count).to be == grandchildren.count

          grandchildren.each do |directory|
            expect(directories).to include DirectorySerializer.serialize(directory, **options)
          end # each
        } # end examples
      end # describe

      describe 'with many features' do
        before(:each) do
          [resource, *children, *grandchildren].each do |directory|
            3.times { directory.features << create(:page, :content => build(:content)) }
          end # each
        end # before each

        include_examples 'should return the resource attributes', ->() {
          expect(serialized['directories']).to be_blank

          expect(serialized['features']).to be_blank
        } # end examples

        describe 'with :recursive => true' do
          before(:each) { options[:recursive] = true }

          include_examples 'should return the resource attributes', ->() {
            expect(serialized).to have_key 'directories'

            directories = serialized.fetch('directories')
            expect(directories).to be_a Array
            expect(directories.count).to be == children.count

            children.each do |directory|
              expect(directories).to include DirectorySerializer.serialize(directory, **options)
            end # each

            expect(directories.first).to have_key 'directories'

            directories = directories.first.fetch('directories')
            expect(directories).to be_a Array
            expect(directories.count).to be == grandchildren.count

            grandchildren.each do |directory|
              expect(directories).to include DirectorySerializer.serialize(directory, **options)
            end # each
          } # end examples
        end # describe

        describe 'with :relations => :all' do
          before(:each) { options[:relations] = :all }

          include_examples 'should return the resource attributes', ->() {
            expect(serialized).to have_key 'features'

            features = serialized.fetch('features')
            expect(features).to be_a Array
            expect(features.count).to be == resource.features.count

            resource.features.each do |page|
              expect(features).to include PageSerializer.serialize(page)
            end # each
          } # end examples
        end # describe

        describe 'with :relations => :all and :recursive => true' do
          before(:each) { options.merge! :relations => :all, :recursive => true }

          include_examples 'should return the resource attributes', ->() {
            expect(serialized).to have_key 'features'

            features = serialized.fetch('features')
            expect(features).to be_a Array
            expect(features.count).to be == resource.features.count

            resource.features.each do |page|
              expect(features).to include PageSerializer.serialize(page)
            end # each

            expect(serialized).to have_key 'directories'

            directories = serialized.fetch('directories')
            expect(directories).to be_a Array
            expect(directories.count).to be == children.count

            children.each do |directory|
              expect(directories).to include DirectorySerializer.serialize(directory, **options)
            end # each

            directories.each do |serialized_directory|
              features = serialized_directory.fetch('features')
              expect(features).to be_a Array
              expect(features.count).to be == resource.features.count
            end # each

            expect(directories.first).to have_key 'directories'

            directories = directories.first.fetch('directories')
            expect(directories).to be_a Array
            expect(directories.count).to be == grandchildren.count

            grandchildren.each do |directory|
              expect(directories).to include DirectorySerializer.serialize(directory, **options)
            end # each

            directories.each do |serialized_directory|
              features = serialized_directory.fetch('features')
              expect(features).to be_a Array
              expect(features.count).to be == resource.features.count
            end # each
          } # end examples
        end # describe
      end # describe
    end # describe
  end # describe
end # describe
