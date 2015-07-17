# spec/models/features/page_spec.rb

require 'rails_helper'

RSpec.describe Page, :type => :model do
  let(:attributes) { attributes_for(:page) }
  let(:instance)   { described_class.new attributes }

  shared_context 'with generic content' do
    let(:content)    { build :content }
    let(:attributes) { super().merge :content => content }
  end # shared_context

  ### Class Methods ###

  describe '::default_content_type' do
    it { expect(described_class).to have_reader(:default_content_type).with(:text) }
  end # describe

  describe '::reserved_slugs' do
    it { expect(described_class).to have_reader(:reserved_slugs) }

    it { expect(described_class.reserved_slugs).to include 'admin' }

    it 'does not contain "index"' do
      expect(described_class.reserved_slugs).not_to include 'index'
    end # it

    it 'contains resourceful actions' do
      expect(described_class.reserved_slugs).to include *%w(
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

  describe '#published_at' do
    it { expect(instance).to have_property(:published_at) }

    it 'is set by #publish' do
      expect { instance.publish }.to change(instance, :published_at).to be_a ActiveSupport::TimeWithZone
    end # it
  end # describe

  ### Relations ###

  describe '#content' do
    it { expect(instance).to have_reader(:content).with(nil) }

    wrap_context 'with generic content' do
      it { expect(instance.content).to be == content }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    wrap_context 'with generic content' do
      it { expect(instance).to be_valid }
    end # context

    describe 'content must be present' do
      let(:attributes) { super().merge :content => nil }

      it { expect(instance).to have_errors.on(:content).with_message("can't be blank") }
    end # describe

    describe 'slug must not match reserved values' do
      context 'with "index"' do
        let(:attributes) { super().merge :slug => 'index' }

        it { expect(instance).not_to have_errors.on(:slug) }
      end # context

      context 'with "admin"' do
        let(:attributes) { super().merge :slug => 'admin' }

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
