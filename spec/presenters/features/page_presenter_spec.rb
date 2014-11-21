# spec/presenters/features/page_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/page_presenter'

RSpec.describe PagePresenter, :type => :decorator do
  let(:attributes) { {} }
  let(:page)       { build(:page, attributes) }
  let(:instance)   { described_class.new page }

  describe '#error_messages' do
    it { expect(instance).to have_reader(:error_messages).with([]) }

    context 'with multiple error messages' do
      let(:errors) do
        [ "Title can't be blank",
          'Slug is already taken',
          "Streams can't be crossed"
        ] # end array
      end # let

      before(:each) do
        errors.each do |message|
          words = message.split(/\s+/)

          page.errors.add(words.shift.downcase, words.join(' '))
        end # each
      end # before each

      it { expect(instance.error_messages).to contain_exactly(*errors) }

      context 'with content error messages' do
        let(:attributes) { super().merge :content => build(:content) }
        let(:content_errors) do
          [ "Text content can't be blank",
            "Picture content depicts a weeping angel. Any representation of"\
            " an angel becomes an angel. Don't look away. Don't even blink."\
            "Blink and you're dead."
          ] # end array
        end # let
        let(:expected) do
          errors + content_errors
        end # let

        before(:each) do
          page.errors.add('content', 'is invalid')

          content_errors.each do |message|
            words = message.split(/\s+/)

            page.content.errors.add(words.shift.downcase, words.join(' '))
          end # each
        end # before each

        it { expect(instance.error_messages).to contain_exactly(*expected) }
      end # context
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
