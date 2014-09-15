# spec/models/features/page_spec.rb

require 'rails_helper'

RSpec.describe Page, :type => :model do
  let(:attributes) { attributes_for(:page) }
  let(:instance)   { described_class.new attributes }

  shared_context 'with generic content', :content => :one do
    let(:content)    { build :content }
    let(:attributes) { super().merge :content => content }
  end # shared_context

  ### Relations ###

  describe '#content' do
    it { expect(instance).to have_reader(:content).with(nil) }

    context 'with generic content', :content => :one do
      it { expect(instance.content).to be == content }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    context 'with generic content', :content => :one do
      it { expect(instance).to be_valid }
    end # context

    describe 'content must be present' do
      let(:attributes) { super().merge :content => nil }

      it { expect(instance).to have_errors.on(:content).with_message("can't be blank") }
    end # describe
  end # describe
end # describe
