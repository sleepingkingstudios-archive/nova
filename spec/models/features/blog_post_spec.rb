# spec/models/features/blog_post_spec.rb

require 'rails_helper'

RSpec.describe BlogPost, :type => :model do
  let(:attributes) { attributes_for(:blog_post) }
  let(:instance)   { described_class.new attributes }

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

  describe '#validation' do
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
  end # describe
end # describe
