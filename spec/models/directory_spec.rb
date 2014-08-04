# spec/models/directory_spec.rb

require 'rails_helper'

RSpec.describe Directory, :type => :model do
  let(:attributes) { FactoryGirl.attributes_for :directory }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a parent directory' do
    let(:parent)     { FactoryGirl.build :directory }
    let(:attributes) { super().merge :parent => parent }
  end # shared_context

  shared_context 'with many ancestor directories' do
    let(:ancestors) do
      [].tap do |ary|
        3.times { |index| ary << FactoryGirl.create(:directory, :parent => ary[index - 1]) }
      end # tap
    end # let
    let(:parent)     { ancestors.last }
    let(:attributes) { super().merge :parent => parent }
  end # shared_context

  ### Class Methods ###

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
        expect { described_class.find_by_ancestry values }.to raise_error
      end # it
    end # describe

    describe 'with an invalid path with many values' do
      include_context 'with many ancestor directories'

      let(:values) { ancestors.map(&:slug).push('missing-child') }

      it 'raises an error' do
        expect { described_class.find_by_ancestry values }.to raise_error
      end # it
    end # describe

    describe 'with a valid path with one value' do
      let!(:directory) { FactoryGirl.create :directory, attributes }
      let(:values)     { [directory.slug] }

      it 'does not raise an error' do
        expect { described_class.find_by_ancestry values }.not_to raise_error
      end # it

      it 'returns the directory' do
        expect(described_class.find_by_ancestry values).to be == directory
      end # it
    end # describe

    describe 'with a valid path with many values' do
      include_context 'with many ancestor directories'

      let!(:directory) { FactoryGirl.create :directory, attributes }
      let(:values)     { ancestors.push(directory).map(&:slug) }

      it 'does not raise an error' do
        expect { described_class.find_by_ancestry values }.not_to raise_error
      end # it

      it 'returns the directory' do
        expect(described_class.find_by_ancestry values).to be == directory
      end # it
    end # describe
  end # describe

  describe '::roots' do
    it { expect(described_class).to respond_to(:roots).with(0).arguments }

    it 'returns a Mongoid criteria' do
      expect(described_class.roots).to be_a Mongoid::Criteria
    end # it

    describe 'with three parents and nine children' do
      let(:parents) { Array.new(3).map { FactoryGirl.create :directory } }
      let!(:children) do
        parents.map do |parent|
          Array.new(3).map { FactoryGirl.create :directory, :parent => parent }
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
    let(:value) { FactoryGirl.attributes_for(:directory).fetch(:title).parameterize }

    it { expect(instance).to have_property :slug }

    it 'sets #slug_lock to true' do
      expect { instance.slug = value }.to change(instance, :slug_lock).to(true)
    end # it
  end # describe

  describe '#slug_lock' do
    it { expect(instance).to have_property :slug_lock }
  end # describe

  ### Relations ###

  describe 'parent' do
    it { expect(instance).to respond_to(:parent).with(0).arguments }

    it { expect(instance.parent).to be nil }
  end # describe

  describe 'children' do
    it { expect(instance).to respond_to(:children).with(0).arguments }

    it { expect(instance.children).to be == [] }
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
      before(:each) { FactoryGirl.create :directory, :slug => instance.slug }

      it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }

      context do
        include_context 'with a parent directory'

        it { expect(instance).not_to have_errors.on(:slug) }
      end # context
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#ancestors' do
    it { expect(instance).to respond_to(:ancestors).with(0).arguments }

    it { expect(instance.ancestors).to be == [] }

    describe 'with a parent directory' do
      include_context 'with a parent directory'

      it { expect(instance.ancestors).to be == [parent] }
    end # describe

    describe 'with many ancestor directories' do
      include_context 'with many ancestor directories'

      it { expect(instance.ancestors).to be == ancestors }
    end # describe
  end # describe

  describe '#root?' do
    it { expect(instance).to respond_to(:root?).with(0).arguments }

    it { expect(instance.root?).to be true }

    describe 'with a parent directory' do
      include_context 'with a parent directory'

      it { expect(instance.root?).to be false }
    end # describe
  end # describe
end # describe
