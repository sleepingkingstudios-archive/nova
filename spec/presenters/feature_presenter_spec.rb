# spec/presenters/feature_presenter_spec.rb

require 'rails_helper'

require 'presenters/feature_presenter'

RSpec.describe FeaturePresenter, :type => :decorator do
  let(:attributes) { {} }
  let(:feature)    { build(:feature, attributes) }
  let(:instance)   { described_class.new feature }

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

          feature.errors.add(words.shift.downcase, words.join(' '))
        end # each
      end # before each

      it { expect(instance.error_messages).to contain_exactly(*errors) }

      context 'with duplicate error messages' do
        let(:errors) do
          [ "Title can't be blank",
            "Title can't be blank",
            'Slug is already taken',
            "Streams can't be crossed",
            "Streams can't be crossed",
            "Streams can't be crossed"
          ] # end array
        end # let

        it { expect(instance.error_messages).to contain_exactly(*errors.uniq) }
      end # context
    end # context
  end # describe

  describe '#feature' do
    it { expect(instance).to have_reader(:feature).with(feature) }
  end # describe

  describe '#icon' do
    let(:expected) { %{<span class="fa fa-cube"></span>} }

    it { expect(instance).to respond_to(:icon).with(0..1).arguments }

    it { expect(instance.icon).to be == expected }

    describe 'with options' do
      let(:expected) { %{<span class="fa fa-cube fa-2x"></span>} }

      it { expect(instance.icon :scale => 2).to be == expected }
    end # describe
  end # describe

  describe '#label' do
    it { expect(instance).to have_reader(:label).with(feature.title) }

    context 'with a changed title' do
      before(:each) do
        feature.save!
        feature.title = attributes_for(:feature).fetch(:title)
      end # before each

      it { expect(instance.label).to be == feature.title_was }
    end # context
  end # describe

  describe '#name' do
    it { expect(instance).to have_reader(:name).with(feature.class.name) }
  end # describe

  describe '#published_status' do
    it { expect(instance).to have_reader(:published_status).with_value('&mdash;'.html_safe) }
  end # describe

  describe '#slug' do
    it { expect(instance).to have_reader(:slug).with(feature.slug) }
  end # describe

  describe '#title' do
    it { expect(instance).to have_reader(:title).with(feature.title) }
  end # describe

  describe '#type' do
    it { expect(instance).to have_reader(:type).with(feature._type) }
  end # describe
end # describe
