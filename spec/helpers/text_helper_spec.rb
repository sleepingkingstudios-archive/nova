# spec/helpers/text_helper_spec.rb

require 'rails_helper'

RSpec.describe TextHelper, :type => :helper do
  let(:instance) do
    double('helper', :render => nil).extend described_class
  end # let

  describe '#humanize_list' do
    it { expect(instance).to respond_to(:humanize_list).with(1).argument.and_keywords(:separator, :last_separator) }

    describe 'with one item' do
      let(:items) { %w(spam) }

      it { expect(instance.humanize_list items).to be == 'spam' }
    end # describe

    describe 'with two items' do
      let(:items) { %w(spam eggs) }

      it { expect(instance.humanize_list items).to be == 'spam and eggs' }

      describe 'with last_separator => " or "' do
        it { expect(instance.humanize_list items, :last_separator => ' or ').to be == 'spam or eggs' }
      end # describe
    end # describe

    describe 'with many items' do
      let(:items) { %w(spam eggs bacon spam) }

      it { expect(instance.humanize_list items).to be == 'spam, eggs, bacon, and spam' }

      describe 'with last_separator => " or "' do
        it { expect(instance.humanize_list items, :last_separator => ' or ').to be == 'spam, eggs, bacon, or spam' }
      end # describe
    end # describe
  end # describe
end # describe
