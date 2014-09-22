# spec/helpers/presenters_helper_spec.rb

require 'rails_helper'

RSpec.describe PresentersHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  describe '#present' do
    let(:object) { Object.new }

    it { expect(instance).to respond_to(:present).with(1).argument }

    it { expect(instance.present object).to be_a Presenter }

    it 'decorates the object' do
      expect(instance.present(object).object).to be object
    end # it

    describe 'with a custom presenter' do
      let(:object) { Feature.new }

      it { expect(instance.present object).to be_a FeaturePresenter }

      it 'decorates the object' do
        expect(instance.present(object).object).to be object
      end # it
    end # describe

    describe 'with a custom presenter for superclass' do
      let(:subclass) { Class.new(Feature) }
      let(:object)   { subclass.new }

      before(:each)  { allow(subclass).to receive(:name).and_return("AnonymousSubclass") }

      it { expect(instance.present object).to be_a FeaturePresenter }

      it 'decorates the object' do
        expect(instance.present(object).object).to be object
      end # it
    end # describe
  end # describe
end # describe
