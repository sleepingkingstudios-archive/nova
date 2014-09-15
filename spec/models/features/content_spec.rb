# spec/models/features/content_spec.rb

require 'rails_helper'

RSpec.describe Content, :type => :model do
  let(:attributes) { attributes_for(:content) }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a container', :container => :one do
    let(:container)  { build :page }
    let(:attributes) { super().merge :container => container }
  end # shared_context

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
