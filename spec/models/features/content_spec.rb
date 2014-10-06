# spec/models/features/content_spec.rb

require 'rails_helper'

RSpec.describe Content, :type => :model do
  include Spec::Contexts::Models::ContentContexts

  let(:attributes) { attributes_for(:content) }
  let(:instance)   { described_class.new attributes }

  ### Class Methods ###

  describe '::content_types' do
    it { expect(described_class).to have_reader(:content_types) }

    it { expect(described_class.content_types).to be_a Hash }

    it 'is immutable' do
      expect { described_class.content_types[:anomalous] = Class.new }.not_to change(described_class, :content_types)
    end # it

    context 'with a subclass' do
      let!(:subclass) do
        class ExampleContent < described_class; end
      end # let

      after(:each) do
        Object.send :remove_const, :ExampleContent

        described_class.content_types.delete :example
      end # after each

      it 'stores the subclass in ::content_types' do
        expect(described_class.content_types.fetch(:example)).to be ExampleContent
      end # it
    end # context
  end # describe

  describe '::content_type_name' do
    it { expect(described_class).to have_reader(:content_type_name).with('Content') }
  end # describe

  ### Relations ###

  describe '#container' do
    it { expect(instance).to have_reader(:container).with(nil) }

    context 'with a container', :container => :one do
      it { expect(instance.container).to be == container }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    context 'with a container', :container => :one do
      it { expect(instance).to be_valid }
    end # context

    describe 'container must be present' do
      let(:attributes) { super().merge :container => nil }

      it { expect(instance).to have_errors.on(:container).with_message "can't be blank" }
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#type' do
    it { expect(instance).to have_reader(:_type).with(described_class.name) }
  end # describe
end # describe
