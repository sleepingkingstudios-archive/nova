# spec/models/features/directory_feature_spec.rb

require 'rails_helper'

RSpec.describe DirectoryFeature, :type => :model do
  let(:attributes) { attributes_for :feature }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a directory' do
    let(:directory)  { build :directory }
    let(:attributes) { super().merge :directory => directory }
  end # shared_context

  shared_context 'with many ancestor directories' do
    let(:directories) do
      [].tap do |ary|
        3.times { |index| ary << create(:directory, :parent => ary[index - 1]) }
      end # tap
    end # let
    let(:directory)  { directories.last }
    let(:attributes) { super().merge :directory => directory }
  end # shared_context

  ### Class Methods ###

  describe '::roots' do
    let(:classes) { FeaturesEnumerator.directory_features.map { |_, hsh| hsh[:class] } << 'DirectoryFeature' }

    it { expect(described_class).to have_reader(:roots) }

    it { expect(described_class.roots).to be_a Mongoid::Criteria }

    it { expect(described_class.roots.selector).to be == { 'directory_id' => nil, '_type' => { '$in' => classes } } }
  end # describe

  ### Relations ###

  describe '#directory' do
    it { expect(instance).to have_reader(:directory_id).with(nil) }

    it { expect(instance).to have_reader(:directory).with(nil) }

    wrap_context 'with a directory' do
      it { expect(instance.directory_id).to be == directory.id }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'slug must be unique within parent_id scope' do
      context 'with a sibling directory' do
        before(:each) { create :directory, :slug => instance.slug }

        it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
      end # context

      context 'with a sibling feature' do
        before(:each) { create :feature, :slug => instance.slug }

        it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
      end # context

      wrap_context 'with a directory' do
        before(:each) { create :directory, :slug => instance.slug }

        it { expect(instance).not_to have_errors.on(:slug) }

        context 'with a sibling directory' do
          before(:each) { create :directory, :parent => directory, :slug => instance.slug }

          it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
        end # context

        context 'with a sibling feature' do
          before(:each) { create :directory_feature, :directory => directory, :slug => instance.slug }

          it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
        end # context
      end # context
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#to_partial_path' do
    it { expect(instance).to respond_to(:to_partial_path).with(0).arguments }

    it { expect(instance.to_partial_path).to be == instance.slug }

    wrap_context 'with a directory' do
      let(:slugs) { [directory.slug, instance.slug] }

      it { expect(instance.to_partial_path).to be == slugs.join('/') }

      context 'with an empty slug' do
        let(:attributes) { super().merge :slug => nil }
        let(:slugs)      { super()[0...-1] }

        it { expect(instance.to_partial_path).to be == slugs.join('/') }
      end # context
    end # describe

    wrap_context 'with many ancestor directories' do
      let(:slugs) { directories.map(&:slug).push(instance.slug) }

      it { expect(instance.to_partial_path).to be == slugs.join('/') }
    end # describe
  end # describe
end # describe
