# spec/presenters/features/page_presenter_spec.rb

# spec/presenters/feature_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/page_presenter'

RSpec.describe PagePresenter, :type => :decorator do
  let(:attributes) { {} }
  let(:page)       { build(:page, attributes) }
  let(:instance)   { described_class.new page }

  describe '#directory' do
    it { expect(instance).to have_reader(:directory) }

    context 'without a directory' do
      let(:attributes) { super().merge :directory => nil }

      it { expect(instance.directory).to be nil }
    end # context

    context 'with a directory' do
      let(:directory)  { create(:directory) }
      let(:attributes) { super().merge :directory => directory }

      it { expect(instance.directory).to be == directory }
    end # context
  end # describe

  describe '#icon' do
    let(:expected) { %{<span class="fa fa-file-o"></span>} }

    it { expect(instance).to respond_to(:icon).with(0..1).arguments }

    it { expect(instance.icon).to be == expected }

    describe 'with options' do
      let(:expected) { %{<span class="fa fa-file-o fa-2x"></span>} }

      it { expect(instance.icon :scale => 2).to be == expected }      
    end # describe
  end # describe

  describe '#index?' do
    it { expect(instance).to have_reader(:index?).with(false) }

    context 'with an index page' do
      let(:attributes) { super().merge :slug => 'index' }

      it { expect(instance.index?).to be true }
    end # context
  end # describe

  describe '#label' do
    it { expect(instance).to have_reader(:label).with(page.title) }

    context 'with a changed title' do
      let(:attributes) { super().merge :content => build(:content) }

      before(:each) do
        page.save!
        page.title = attributes_for(:page).fetch(:title)
      end # before each

      it { expect(instance.label).to be == page.title_was }
    end # context

    context 'with an index page' do
      let(:attributes) { super().merge :slug => 'index' }

      context 'without a directory' do
        let(:attributes) { super().merge :directory => nil }

        it { expect(instance.label).to be == 'Root Directory' }
      end # context

      context 'with a directory' do
        let(:directory)  { create(:directory) }
        let(:attributes) { super().merge :directory => directory }

        it { expect(instance.label).to be == directory.title }
      end # context
    end # context
  end # describe

  describe '#page' do
    it { expect(instance).to have_reader(:page).with(page) }
  end # describe
end # describe
