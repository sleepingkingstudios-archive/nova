# spec/presenters/directory_presenter_spec.rb

require 'rails_helper'

require 'presenters/directory_presenter'

RSpec.describe DirectoryPresenter, :type => :decorator do
  let(:directory)   { build(:directory) }
  let(:instance)    { described_class.new directory }
  let(:empty_value) { '<span class="text-muted">(none)</span>' }

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
      let(:directory) { build(:directory) }

      it { expect(instance.label).to be == directory.title }
    end # context
  end # describe

  describe '#title' do
    it { expect(instance).to have_reader(:title) }

    context 'without a directory' do
      let(:directory) { nil }

      it { expect(instance.title).to be == empty_value }
    end # context

    context 'with a directory' do
      let(:directory) { build(:directory) }

      it { expect(instance.title).to be == directory.title }
    end # context
  end # describe
end # describe
