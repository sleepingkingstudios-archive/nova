# spec/routers/directory_router_spec.rb

require 'rails_helper'

require 'routers/directory_router'

RSpec.describe DirectoryRouter, :type => :decorator do
  let(:directory) { build(:directory) }
  let(:instance)  { described_class.new directory }

  shared_context 'with many features' do
    let(:directory) { super().tap { |dir| dir.try(:save!) } }
    let(:feature_slugs) { %w(katana wakizashi tachi) }
    let!(:features) do
      feature_slugs.map { |slug| create(:feature, :directory => directory, :slug => slug) }
    end # let
  end # shared_context

  shared_context 'with one missing routing parameter' do
    let(:search)  { 'weapons/swords/japanese/tachi'.split('/') }
    let(:found) do
      search[0..2].map { |slug| double('directory', :slug => slug) }
    end # let
    let(:missing) { search[3..3] }
  end # shared_context

  shared_context 'with many missing routing parameters' do
    let(:search)  { 'weapons/swords/japanese/tachi'.split('/') }
    let(:found) do
      search[0..0].map { |slug| double('directory', :slug => slug) }
    end # let
    let(:missing) { search[1..3] }
  end # shared_context

  describe '#directory' do
    it { expect(instance).to have_reader(:directory).with(directory) }
  end # describe

  describe '#route_to' do
    def perform_action
      instance.route_to search, found, missing
    end # method perform_action

    context 'with no features' do
      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        it { expect(perform_action).to be nil }
      end # context

      context 'with many missing routing parameters' do
        include_context 'with many missing routing parameters'

        it { expect(perform_action).to be nil }
      end # context
    end # context

    context 'with many features' do
      include_context 'with many features'

      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        it { expect(perform_action).to be == features.last }
      end # context

      context 'with many missing routing parameters' do
        let(:feature_slugs) { %w(bows polearms swords) }
        let(:feature)       { features.select { |feature| feature.slug == search[1] }.first }

        include_context 'with many missing routing parameters'

        it { expect(perform_action).to be nil }

        it 'updates the routing parameters' do
          perform_action

          expect(instance.search).to be  == search
          expect(instance.found).to be   == found + [feature]
          expect(instance.missing).to be == missing[1..-1]
        end # it
      end # context
    end # context

    context 'with the root directory' do
      let(:directory) { nil }

      context 'with no features' do
        context 'with one missing routing parameter' do
          include_context 'with one missing routing parameter'

          it { expect(perform_action).to be nil }
        end # context

        context 'with many missing routing parameters' do
          include_context 'with many missing routing parameters'

          it { expect(perform_action).to be nil }
        end # context
      end # context

      context 'with many features' do
        include_context 'with many features'

        context 'with one missing routing parameter' do
          include_context 'with one missing routing parameter'

          it { expect(perform_action).to be == features.last }
        end # context

        context 'with many missing routing parameters' do
          let(:feature_slugs) { %w(bows polearms swords) }
          let(:feature)       { features.select { |feature| feature.slug == search[1] }.first }

          include_context 'with many missing routing parameters'

          it { expect(perform_action).to be nil }

          it 'updates the routing parameters' do
            perform_action

            expect(instance.search).to be  == search
            expect(instance.found).to be   == found + [feature]
            expect(instance.missing).to be == missing[1..-1]
          end # it
        end # context
      end # context
    end # context
  end # describe

  describe '#route_to!' do
    def perform_action
      instance.route_to! search, found, missing
    end # method perform_action

    context 'with no features' do
      shared_examples 'raises an error' do
        it 'raises an error' do
          expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
            expect(exception.search).to be  == search
            expect(exception.found).to be   == found
            expect(exception.missing).to be == missing
          end # raise_error
        end # it
      end

      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        expect_behavior 'raises an error'
      end # context

      context 'with many missing routing parameters' do
        include_context 'with many missing routing parameters'

        expect_behavior 'raises an error'
      end # context
    end # context

    context 'with many features' do
      include_context 'with many features'

      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        it { expect(perform_action).to be == features.last }
      end # context

      context 'with many missing routing parameters' do
        let(:feature_slugs) { %w(bows polearms swords) }
        let(:feature)       { features.select { |feature| feature.slug == search[1] }.first }

        include_context 'with many missing routing parameters'

        it 'raises an error' do
          expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
            expect(exception.search).to be  == search
            expect(exception.found).to be   == found + [feature]
            expect(exception.missing).to be == missing[1..-1]
          end # raise_error
        end # it
      end # context
    end # context

    context 'with the root directory' do
      let(:directory) { nil }

      context 'with no features' do
        shared_examples 'raises an error' do
          it 'raises an error' do
            expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
              expect(exception.search).to be  == search
              expect(exception.found).to be   == found
              expect(exception.missing).to be == missing
            end # raise_error
          end # it
        end

        context 'with one missing routing parameter' do
          include_context 'with one missing routing parameter'

          expect_behavior 'raises an error'
        end # context

        context 'with many missing routing parameters' do
          include_context 'with many missing routing parameters'

          expect_behavior 'raises an error'
        end # context
      end # context

      context 'with many features' do
        include_context 'with many features'

        context 'with one missing routing parameter' do
          include_context 'with one missing routing parameter'

          it { expect(perform_action).to be == features.last }
        end # context

        context 'with many missing routing parameters' do
          let(:feature_slugs) { %w(bows polearms swords) }
          let(:feature)       { features.select { |feature| feature.slug == search[1] }.first }

          include_context 'with many missing routing parameters'

          it 'raises an error' do
            expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
              expect(exception.search).to be  == search
              expect(exception.found).to be   == found + [feature]
              expect(exception.missing).to be == missing[1..-1]
            end # raise_error
          end # it
        end # context
      end # context
    end # context
  end # describe
end # describe
