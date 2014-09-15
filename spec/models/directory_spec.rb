# spec/models/directory_spec.rb

require 'rails_helper'

RSpec.describe Directory, :type => :model do
  let(:attributes) { attributes_for :directory }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a parent directory', :parent => :one do
    let(:parent)     { build :directory }
    let(:attributes) { super().merge :parent => parent }
  end # shared_context

  shared_context 'with many ancestor directories', :ancestors => :many do
    let(:ancestors) do
      [].tap do |ary|
        3.times { |index| ary << create(:directory, :parent => ary[index - 1]) }
      end # tap
    end # let
    let(:parent)     { ancestors.last }
    let(:attributes) { super().merge :parent => parent }
  end # shared_context

  shared_context 'with many child directories', :children => :one do
    let!(:children) do
      Array.new(3).map do
        instance.children.build attributes_for(:directory)
      end # map
    end # let!
  end # shared_context

  shared_context 'with many features', :features => :many do
    let!(:features) do
      Array.new(3).map do
        instance.features.build attributes_for(:feature)
      end # map
    end # let!
  end # shared_context

  shared_context 'with many example features', :example_features => :many do
    let!(:example_features) do
      Array.new(3).map do
        create :example_feature, :directory => instance
      end # map
    end # let!
  end # shared_context

  ### Class Methods ###

  describe '::feature' do
    it { expect(described_class).to respond_to(:feature).with(1..2).arguments }

    describe 'with a model name and class' do
      def self.model_name
        :example_feature
      end # class method model_name

      let(:model_name)  { self.class.model_name }
      let(:model_class) { "Spec::Models::#{model_name.to_s.camelize}".constantize }
      let(:scope_name)  { model_name.to_s.pluralize }

      before(:each) { Directory.feature model_name, :class => model_class }

      describe "##{model_name.to_s.pluralize}" do
        let(:criteria) { instance.send(scope_name) }

        it { expect(instance).to respond_to(model_name.to_s.pluralize).with(0).arguments }

        it { expect(criteria).to be_a Mongoid::Criteria }

        it { expect(criteria.selector.fetch('directory_id')).to be == instance.id }

        it { expect(criteria.selector.fetch('_type')).to be == model_class.to_s }

        context 'with many example features', :features => :many, :example_features => :many do
          it 'returns the example features' do
            expect(criteria.to_a).to contain_exactly *example_features
          end # it
        end # context
      end # describe

      describe "#build_#{model_name.to_s}" do
        def build_feature
          instance.send :"build_#{model_name.to_s}", feature_attributes
        end # method create_feature

        let(:feature_attributes) { {} }

        it { expect(instance).to respond_to(:"build_#{model_name.to_s}").with(1).argument }

        it { expect(build_feature).to be_a model_class }

        it { expect(build_feature.directory_id).to be == instance.id }
      end # describe

      describe "#create_#{model_name.to_s}" do
        def create_feature
          instance.send :"create_#{model_name.to_s}", feature_attributes
        end # method create_feature

        it { expect(instance).to respond_to(:"create_#{model_name.to_s}").with(1).argument }

        describe 'with invalid attributes' do
          let(:feature_attributes) { {} }

          it { expect(create_feature).to be_a model_class }

          it 'does not create a new feature' do
            expect { create_feature }.not_to change(instance.send(model_name.to_s.pluralize), :count)
          end # it
        end # describe

        describe 'with valid attributes' do
          let(:feature_attributes) { attributes_for(:example_feature) }

          it { expect(create_feature).to be_a model_class }

          it 'creates a new feature' do
            expect { create_feature }.to change(instance.send(model_name.to_s.pluralize), :count).by(1)
          end # it
        end # describe
      end # describe

      describe "#create_#{model_name.to_s}!" do
        def create_feature
          instance.send :"create_#{model_name.to_s}!", feature_attributes
        end # method create_feature

        it { expect(instance).to respond_to(:"create_#{model_name.to_s}!").with(1).argument }

        describe 'with invalid attributes' do
          let(:feature_attributes) { {} }

          it 'raises an error' do
            expect { create_feature }.to raise_error Mongoid::Errors::Validations
          end # it

          it 'does not create a new feature' do
            expect {
              begin create_feature; rescue Mongoid::Errors::Validations; end
            }.not_to change(instance.send(model_name.to_s.pluralize), :count)
          end # it
        end # describe

        describe 'with valid attributes' do
          let(:feature_attributes) { attributes_for(:example_feature) }

          it { expect(create_feature).to be_a model_class }

          it 'creates a new feature' do
            expect { create_feature }.to change(instance.send(model_name.to_s.pluralize), :count).by(1)
          end # it
        end # describe
      end # describe
    end # describe
  end # describe

  describe '::find_by_ancestry' do
    it { expect(described_class).to respond_to(:find_by_ancestry).with(1).arguments }

    describe 'with nil' do
      it 'raises an error' do
        expect { described_class.find_by_ancestry nil }.to raise_error(ArgumentError)
      end # it
    end # describe

    describe 'with an empty array' do
      it 'raises an error' do
        expect { described_class.find_by_ancestry [] }.to raise_error(ArgumentError)
      end # it
    end # describe

    describe 'with an invalid path with one value' do
      let(:values) { ['this-is-a-slug'] }

      it 'raises an error' do
        expect { described_class.find_by_ancestry values }.to raise_error(Directory::NotFoundError)
      end # it
    end # describe

    describe 'with an invalid path with many values', :ancestors => :many do
      let(:values) { ancestors.map(&:slug).push('missing-child') }

      it 'raises an error' do
        expect { described_class.find_by_ancestry values }.to raise_error(Directory::NotFoundError)
      end # it
    end # describe

    describe 'with a valid path with one value' do
      let!(:directory) { create :directory, attributes }
      let(:values)     { [directory.slug] }

      it 'does not raise an error' do
        expect { described_class.find_by_ancestry values }.not_to raise_error
      end # it

      it 'returns the directories' do
        expect(described_class.find_by_ancestry values).to be == [directory]
      end # it
    end # describe

    describe 'with a valid path with many values', :ancestors => :many do
      let!(:directory) { create :directory, attributes }
      let(:values)     { ancestors.dup.push(directory).map(&:slug) }

      it 'does not raise an error' do
        expect { described_class.find_by_ancestry values }.not_to raise_error
      end # it

      it 'returns the directories' do
        expect(described_class.find_by_ancestry values).to be == ancestors.dup.push(directory)
      end # it
    end # describe
  end # describe

  describe '::roots' do
    it { expect(described_class).to respond_to(:roots).with(0).arguments }

    it 'returns a Mongoid criteria' do
      expect(described_class.roots).to be_a Mongoid::Criteria
    end # it

    describe 'with three parents and nine children' do
      let(:parents) { Array.new(3).map { create :directory } }
      let!(:children) do
        parents.map do |parent|
          Array.new(3).map { create :directory, :parent => parent }
        end.flatten # each
      end # let

      it 'returns the parents' do
        expect(Set.new described_class.roots.to_a).to be == Set.new(parents)
      end # let
    end # describe
  end # describe

  ### Attributes ###

  describe '#title' do
    it { expect(instance).to have_property :title }
  end # describe

  describe '#slug' do
    let(:value) { attributes_for(:directory).fetch(:title).parameterize }

    it { expect(instance).to have_property :slug }

    it 'is generated from the title' do
      expect(instance.slug).to be == instance.title.parameterize
    end # it

    it 'sets #slug_lock to true' do
      expect { instance.slug = value }.to change(instance, :slug_lock).to(true)
    end # it
  end # describe

  describe '#slug_lock' do
    it { expect(instance).to have_property :slug_lock }
  end # describe

  ### Relations ###

  describe '#parent' do
    it { expect(instance).to have_reader(:parent_id).with(nil) }

    it { expect(instance).to have_reader(:parent).with(nil) }

    context 'with a parent directory', :parent => :one do
      it { expect(instance.parent_id).to be == parent.id }
    end # context
  end # describe

  describe '#children' do
    it { expect(instance).to have_reader(:children).with([]) }

    context 'with many child directories', :children => :one do
      it { expect(instance.children).to be == children }
    end # context
  end # describe

  describe '#features' do
    it { expect(instance).to have_reader(:features).with([]) }

    context 'with many features', :features => :many do
      it { expect(instance.features).to be == features }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'title must be present' do
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:title).with_message("can't be blank") }
    end # describe

    describe 'slug must be present' do
      let(:attributes) { super().merge :slug => nil }

      it { expect(instance).to have_errors.on(:slug).with_message("can't be blank") }
    end # describe

    describe 'slug must be unique within parent_id scope' do
      before(:each) { create :directory, :slug => instance.slug }

      it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }

      context 'with a parent directory', :parent => :one do
        it { expect(instance).not_to have_errors.on(:slug) }
      end # context
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#ancestors' do
    it { expect(instance).to respond_to(:ancestors).with(0).arguments }

    it { expect(instance.ancestors).to be == [] }

    describe 'with a parent directory', :parent => :one do
      it { expect(instance.ancestors).to be == [parent] }
    end # describe

    describe 'with many ancestor directories', :ancestors => :many do
      it { expect(instance.ancestors).to be == ancestors }
    end # describe
  end # describe

  describe '#root?' do
    it { expect(instance).to respond_to(:root?).with(0).arguments }

    it { expect(instance.root?).to be true }

    describe 'with a parent directory', :parent => :one do
      it { expect(instance.root?).to be false }
    end # describe
  end # describe
end # describe
