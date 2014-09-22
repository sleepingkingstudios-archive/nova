# spec/presenters/directory_presenter_spec.rb

require 'rails_helper'

require 'presenters/directory_presenter'

RSpec.describe DirectoryPresenter, :type => :decorator do
  let(:attributes)  { {} }
  let(:directory)   { build(:directory, attributes) }
  let(:instance)    { described_class.new directory }
  let(:empty_value) { '<span class="text-muted">(none)</span>' }

  describe '#children' do
    it { expect(instance).to have_reader(:children) }

    context 'without a directory' do
      let(:roots) do
        %w(weapons potions spells).map { |slug| double(:directory, :slug => slug) }
      end # let
      let(:directory) { nil }

      before(:each) { allow(Directory).to receive(:roots).and_return(roots) }

      it { expect(instance.children).to be == roots }
    end # context

    context 'with a directory' do
      let(:children) do
        %w(swords spears bows).map { |slug| double(:directory, :slug => slug) }
      end # let

      before(:each) { allow(directory).to receive(:children).and_return(children) }

      it { expect(instance.children).to be == children }
    end # context
  end # describe

  describe '#directory' do
    it { expect(instance).to have_reader(:directory).with(directory) }
  end # describe

  describe '#label' do
    it { expect(instance).to have_reader(:label) }

    context 'without a directory' do
      let(:directory) { nil }

      it { expect(instance.label).to be == 'Root Directory' }
    end # context

    context 'with a directory' do
      it { expect(instance.label).to be == directory.title }

      context 'with a changed title' do
        before(:each) do
          directory.save!
          directory.title = attributes_for(:directory).fetch(:title)
        end # before each

        it { expect(instance.label).to be == directory.title_was }
      end # context
    end # context
  end # describe

  describe '#parent' do
    it { expect(instance).to have_reader(:parent) }

    context 'without a directory' do
      let(:directory) { nil }

      it { expect(instance.parent).to be nil }
    end # context

    context 'with a directory' do
      context 'without a parent' do
        it { expect(instance.parent).to be nil }
      end # context

      context 'with a parent' do
        let(:parent)     { create(:directory) }
        let(:attributes) { super().merge :parent => parent }

        it { expect(instance.parent).to be == parent }
      end # context
    end # context 
  end # describe

  describe '#parent_link' do
    it { expect(instance).to respond_to(:parent_link).with(0..1).arguments }

    context 'without a directory' do
      let(:directory) { nil }

      it { expect(instance.parent_link).to be == empty_value }

      context 'with action => index' do
        it { expect(instance.parent_link :index).to be == empty_value }
      end # context
    end # context

    context 'with a directory' do
      context 'without a parent' do
        let(:link) { %{<a href="/">Root Directory</a>} }

        it { expect(instance.parent_link).to be == link }

        context 'with action => index' do
          let(:link) { %{<a href="/index">Root Directory</a>} }

          it { expect(instance.parent_link :index).to be == link }
        end # context
      end # context

      context 'with a parent' do
        let(:parent)     { create(:directory) }
        let(:attributes) { super().merge :parent => parent }
        let(:link)       { %{<a href="/#{parent.slug}">#{parent.title}</a>} }

        it { expect(instance.parent_link).to be == link }

        context 'with action => index' do
          let(:link) { %{<a href="/#{parent.slug}/index">#{parent.title}</a>} }

          it { expect(instance.parent_link :index).to be == link }
        end # context
      end # context
    end # context
  end # describe

  describe '#slug' do
    it { expect(instance).to have_reader(:slug) }

    context 'without a directory' do
      let(:directory) { nil }

      it { expect(instance.slug).to be == empty_value }
    end # context

    context 'with a directory' do
      it { expect(instance.slug).to be == instance.slug }
    end # context
  end # describe

  describe '#title' do
    it { expect(instance).to have_reader(:title) }

    context 'without a directory' do
      let(:directory) { nil }

      it { expect(instance.title).to be == empty_value }
    end # context

    context 'with a directory' do
      it { expect(instance.title).to be == directory.title }
    end # context
  end # describe
end # describe
