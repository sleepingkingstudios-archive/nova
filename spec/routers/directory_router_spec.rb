# spec/routers/directory_router_spec.rb

require 'rails_helper'

require 'routers/directory_router'

RSpec.describe DirectoryRouter, :type => :decorator do
  let(:directory) { build(:directory) }
  let(:instance)  { described_class.new directory }

  shared_context 'with the root directory' do
    let(:directories) { [] }
    let(:directory)   { nil }
  end # shared_context

  shared_context 'with nested directories' do
    let(:directory_names) { %w(weapons swords japanese) }
    let(:directories)     { directory_names.each.with_index.with_object([]) { |(name, index), ary| ary << create(:directory, :parent => ary[index - 1]) } }
    let(:directory)       { directories.last }

    before(:each) { search.concat(directory_names) }
  end # shared_context

  shared_context 'with many features' do
    let(:directory) { super().tap { |dir| dir.try(:save!) } }
    let(:feature_slugs) { %w(katana wakizashi tachi) }
    let!(:features) do
      feature_slugs.map { |slug| create(:directory_feature, :directory => directory, :slug => slug) }
    end # let
  end # shared_context

  shared_context 'with one missing routing parameter' do
    before(:each) do
      search << 'tachi'
      found.concat directories
      missing << 'tachi'
    end # before each
  end # shared_context

  shared_context 'with many missing routing parameters' do
    before(:each) do
      search << 'tachi' << 'nakago' << 'mei'
      found.concat(directories)
      missing << 'tachi' << 'nakago' << 'mei'
    end # before each
  end # shared_context

  shared_examples 'delegates to a subfeature router' do
    let(:subfeature)     { double('feature') }
    let(:feature_router) { double('router', :route_to => subfeature) }

    before(:each) do
      allow(instance).to receive(:decorate).with(features.last, :Router).and_return(feature_router)
    end # before each

    it 'returns the subfeature' do
      expect(perform_action).to be == subfeature
    end # it
  end # shared_examples

  let(:features) { [] }
  let(:search)   { [] }
  let(:found)    { [] }
  let(:missing)  { [] }

  describe '#directory' do
    it { expect(instance).to have_reader(:directory).with(directory) }
  end # describe

  describe '#route_to' do
    def perform_action
      instance.route_to search, found, missing
    end # method perform_action

    context 'with nested directories' do
      include_context 'with nested directories'

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
          include_context 'with many missing routing parameters'

          it { expect(perform_action).to be nil }

          it 'updates the routing parameters' do
            perform_action

            expect(instance.search).to be  == search
            expect(instance.found).to be   == found + [features.last]
            expect(instance.missing).to be == missing[1..-1]
          end # it

          expect_behavior 'delegates to a subfeature router'
        end # context
      end # context
    end # context

    context 'with the root directory' do
      include_context 'with the root directory'

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
          include_context 'with many missing routing parameters'

          it { expect(perform_action).to be nil }

          it 'updates the routing parameters' do
            perform_action

            expect(instance.search).to be  == search
            expect(instance.found).to be   == found + [features.last]
            expect(instance.missing).to be == missing[1..-1]
          end # it

          expect_behavior 'delegates to a subfeature router'
        end # context
      end # context
    end # context
  end # describe

  describe '#route_to!' do
    def perform_action
      instance.route_to! search, found, missing
    end # method perform_action

    context 'with nested directories' do
      context 'with no features' do
        shared_examples 'raises an error' do
          it 'raises an error' do
            expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
              expect(exception.search).to be  == search
              expect(exception.found).to be   == found
              expect(exception.missing).to be == missing
            end # raise_error
          end # it
        end # shared examples

        context 'with one missing routing parameter' do
          include_context 'with one missing routing parameter'

          expect_behavior 'raises an error'
        end # context

        context 'with many missing routing parameters' do
          include_context 'with many missing routing parameters'

          expect_behavior 'raises an error'
        end # context
      end # context

      include_context 'with nested directories'

      context 'with many features' do
        include_context 'with many features'

        context 'with one missing routing parameter' do
          include_context 'with one missing routing parameter'

          it { expect(perform_action).to be == features.last }
        end # context

        context 'with many missing routing parameters' do
          include_context 'with many missing routing parameters'

          it 'raises an error' do
            expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
              expect(exception.search).to be  == search
              expect(exception.found).to be   == found + [features.last]
              expect(exception.missing).to be == missing[1..-1]
            end # raise_error
          end # it

          expect_behavior 'delegates to a subfeature router'
        end # context
      end # context
    end # context

    context 'with the root directory' do
      include_context 'with the root directory'

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
          include_context 'with many missing routing parameters'

          it 'raises an error' do
            expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
              expect(exception.search).to be  == search
              expect(exception.found).to be   == found + [features.last]
              expect(exception.missing).to be == missing[1..-1]
            end # raise_error
          end # it

          expect_behavior 'delegates to a subfeature router'
        end # context
      end # context
    end # context
  end # describe
end # describe
