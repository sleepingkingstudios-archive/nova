# spec/models/settings/navigation_list_item_spec.rb

require 'rails_helper'

RSpec.describe NavigationListItem, :type => :model do
  shared_context 'with a list' do
    let!(:list) { build(:navigation_list) }

    before(:each) { instance.list = list }
  end # shared_context

  let(:attributes) { attributes_for(:navigation_list_item) }
  let(:instance)   { described_class.new(attributes) }

  ### Attributes ###

  describe '#label' do
    it { expect(instance).to have_property(:label).with_value(attributes[:label]) }
  end # describe

  describe '#url' do
    it { expect(instance).to have_property(:url).with_value(attributes[:url]) }
  end # describe

  ### Relations ###

  describe '#list' do
    it { expect(instance).to have_reader(:list).with_value(nil) }

    context 'with a list' do
      include_context 'with a list'

      it { expect(instance).to have_reader(:list).with_value(list) }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    context 'with a list' do
      include_context 'with a list'

      it { expect(instance).to be_valid }
    end # context

    describe 'label must be present' do
      let(:attributes) { super().merge :label => nil }

      it { expect(instance).to have_errors.on(:label).with_message("can't be blank") }
    end # describe

    describe 'list must be present' do
      let(:attributes) { super().merge :list => nil }

      it { expect(instance).to have_errors.on(:list).with_message("can't be blank") }
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#value' do
    it { expect(instance).to have_reader(:value).with_value(be_a Hash) }

    it 'serializes the label and url' do
      hsh  = instance.value
      keys = %w(label url)

      expect(hsh.keys).to contain_exactly(*keys)

      keys.each do |key|
        expect(hsh.fetch key).to be == attributes[key.intern]
      end # each
    end # it
  end # describe
end # describe
