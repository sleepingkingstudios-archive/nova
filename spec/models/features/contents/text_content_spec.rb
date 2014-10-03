# spec/models/features/contents/text_content_spec.rb

require 'rails_helper'

RSpec.describe TextContent, :type => :model do
  let(:attributes) { attributes_for(:text_content) }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a container', :container => :one do
    let(:container)  { build :page }
    let(:attributes) { super().merge :container => container }
  end # shared_context

  ### Attributes ###

  describe '#text_content' do
    it { expect(instance).to have_property(:text_content) }
  end # describe

  ### Validation ###

  describe 'validation' do
    context 'with a container', :container => :one do
      it { expect(instance).to be_valid }
    end # context

    describe 'text_content must be present' do
      let(:attributes) { super().merge :text_content => nil }

      it { expect(instance).to have_errors.on(:text_content).with_message("can't be blank") }
    end # describe
  end # describe
end # describe
