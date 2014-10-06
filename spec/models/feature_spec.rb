# spec/models/feature_spec.rb

require 'rails_helper'

RSpec.describe Feature, :type => :model do
  let(:attributes) { attributes_for :feature }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a directory', :directories => :one do
    let(:directory)  { build :directory }
    let(:attributes) { super().merge :directory => directory }
  end # shared_context

  shared_context 'with many ancestor directories', :directories => :many do
    let(:directories) do
      [].tap do |ary|
        3.times { |index| ary << create(:directory, :parent => ary[index - 1]) }
      end # tap
    end # let
    let(:directory)  { directories.last }
    let(:attributes) { super().merge :directory => directory }
  end # shared_context

  ### Class Methods ###

  describe '::default_content_type' do
    it { expect(described_class).to have_reader(:default_content_type).with(:text) }
  end # describe

  describe '::reserved_slugs' do
    it { expect(described_class).to have_reader(:reserved_slugs) }

    it { expect(described_class.reserved_slugs).to include 'admin' }

    it 'contains resourceful actions' do
      expect(described_class.reserved_slugs).to include *%w(
        index
        new
        edit
      ) # end array
    end # it

    it 'contains directory and feature names' do
      expect(described_class.reserved_slugs).to include *%w(
        directories
        features
      ) # end array
    end # it
  end # describe

  describe '::roots' do
    it { expect(described_class).to have_reader(:roots) }

    it { expect(described_class.roots).to be_a Mongoid::Criteria }

    it { expect(described_class.roots.selector).to be == { 'directory_id' => nil } }
  end # describe

  ### Attributes ###

  describe '#title' do
    it { expect(instance).to have_property(:title) }
  end # describe

  describe '#slug' do
    let(:value) { attributes_for(:page).fetch(:title).parameterize }

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

  describe '#directory' do
    it { expect(instance).to have_reader(:directory_id).with(nil) }

    it { expect(instance).to have_reader(:directory).with(nil) }

    context 'with a directory', :directories => :one do
      it { expect(instance.directory_id).to be == directory.id }
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
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:slug).with_message("can't be blank") }
    end # describe

    describe 'slug must not match reserved values' do
      context 'with "admin"' do
        let(:attributes) { super().merge :slug => 'admin' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context

      context 'with "index"' do
        let(:attributes) { super().merge :slug => 'index' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context

      context 'with "edit"' do
        let(:attributes) { super().merge :slug => 'edit' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context

      context 'with "directories"' do
        let(:attributes) { super().merge :slug => 'directories' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context
    end # describe

    describe 'slug must be unique within parent_id scope' do
      context 'with a sibling directory' do
        before(:each) { create :directory, :slug => instance.slug }

        it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
      end # context

      context 'with a sibling feature' do
        before(:each) { create :feature, :slug => instance.slug }

        it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
      end # context

      context 'with a parent directory', :directories => :one do
        before(:each) { create :directory, :slug => instance.slug }

        it { expect(instance).not_to have_errors.on(:slug) }

        context 'with a sibling directory' do
          before(:each) { create :directory, :parent => directory, :slug => instance.slug }

          it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
        end # context

        context 'with a sibling feature' do
          before(:each) { create :feature, :directory => directory, :slug => instance.slug }

          it { expect(instance).to have_errors.on(:slug).with_message("is already taken") }
        end # context
      end # context
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#to_partial_path' do
    it { expect(instance).to respond_to(:to_partial_path).with(0).arguments }

    it { expect(instance.to_partial_path).to be == instance.slug }

    describe 'with a directory', :directories => :one do
      let(:slugs) { [directory.slug, instance.slug] }

      it { expect(instance.to_partial_path).to be == slugs.join('/') }

      context 'with an empty slug' do
        let(:attributes) { super().merge :slug => nil }
        let(:slugs)      { super()[0...-1] }

        it { expect(instance.to_partial_path).to be == slugs.join('/') }        
      end # context
    end # describe

    describe 'with many ancestor directories', :directories => :many do
      let(:slugs) { directories.map(&:slug).push(instance.slug) }

      it { expect(instance.to_partial_path).to be == slugs.join('/') }
    end # describe
  end # describe
end # describe
