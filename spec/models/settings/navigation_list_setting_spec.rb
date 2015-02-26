# spec/models/settings/navigation_list_setting_spec.rb

require 'rails_helper'

RSpec.describe NavigationListSetting, :type => :model do
  shared_context 'with a list' do
    let!(:list) { build(:navigation_list, :container => instance) }
  end # shared_context

  shared_context 'with many items' do
    let!(:items) do
      Array.new(3).map { build(:navigation_list_item, :list => list) }
    end # let!
  end # shared_contex

  let(:attributes) { attributes_for(:navigation_list_setting) }
  let(:instance)   { described_class.new attributes }

  ### Relations ###

  describe '#list' do
    it { expect(instance).to have_reader(:list).with(nil) }

    context 'with a list' do
      include_context 'with a list'

      it { expect(instance).to have_reader(:list).with(list) }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    it { expect(instance).to be_valid }

    describe 'with :validate_presence => true' do
      let(:attributes) { super().merge :options => (super()[:options] || {}).merge(:validate_presence => true) }

      describe 'list must be present' do
        let(:attributes) { super().merge :list => nil }

        it { expect(instance).to have_errors.on(:list).with_message("can't be blank") }
      end # describe
    end # describe

    describe 'with a list' do
      include_context 'with a list'

      it { expect(instance).to be_valid }

      describe 'with :validate_presence => true' do
        let(:attributes) { super().merge :options => (super()[:options] || {}).merge(:validate_presence => true) }

        describe "list can't be empty" do
          it { expect(instance).to have_errors.on(:list).with_message("can't be blank") }
        end # describe
      end # describe

      describe 'with many items' do
        include_context 'with many items'

        it { expect(instance).to be_valid }

        describe 'with an invalid item' do
          let(:items) { super() << build(:navigation_list_item, :list => list, :label => nil) }

          it { expect(instance).to have_errors.on("Item #{items.count}'s label").with_message("can't be blank") }
        end # describe
      end # describe
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#value' do
    it { expect(instance).to have_reader(:value).with([]) }

    context 'with a list' do
      include_context 'with a list'

      it { expect(instance.value).to be == [] }

      context 'with many items' do
        include_context 'with many items'

        it { expect(instance.value).to be == items.map(&:value) }
      end # context
    end # context
  end # describe
end # describe
