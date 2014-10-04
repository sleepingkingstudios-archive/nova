# spec/models/features/content_spec.rb

require 'rails_helper'

RSpec.describe Content, :type => :model do
  let(:attributes) { attributes_for(:content) }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a container', :container => :one do
    let(:container)  { build :page }
    let(:attributes) { super().merge :container => container }
  end # shared_context

  ### Class Methods ###

  describe '#content_type' do
    let(:name)  { :example }
    let(:klass) { Class.new }

    before(:each) do
      Object.const_set :ExampleContent, klass
    end # before each

    after(:each) do
      Object.send :remove_const, :ExampleContent if Object.const_defined?(:ExampleContent)
    end # after each

    it { expect(described_class).to respond_to(:content_type).with(1..2).arguments }

    it 'stores the name and type' do
      described_class.content_type name

      expect(described_class.content_types.fetch(name)).to be == klass
    end # it
  end # describe

  describe '#content_types' do
    it { expect(described_class).to have_reader(:content_types) }

    it { expect(described_class.content_types).to be_a Hash }
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
end # describe
