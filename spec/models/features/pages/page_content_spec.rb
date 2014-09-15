# spec/models/features/pages/page_content_spec.rb

require 'rails_helper'

RSpec.describe PageContent, :type => :model do
  let(:attributes) { attributes_for(:page_content) }
  let(:instance)   { described_class.new attributes }

  shared_context 'with a page', :page => :one do
    let(:page)       { build :page }
    let(:attributes) { super().merge :page => page }
  end # shared_context

  ### Relations ###

  describe '#page' do
    it { expect(instance).to have_reader(:page).with(nil) }

    context 'with a page', :page => :one do
      it { expect(instance.page).to be == page }
    end # context
  end # describe

  ### Validation ###

  describe 'validation' do
    context 'with a page', :page => :one do
      it { expect(instance).to be_valid }
    end # context

    describe 'page must be present' do
      let(:attributes) { super().merge :page => nil }

      it { expect(instance).to have_errors.on(:page).with_message "can't be blank" }
    end # describe
  end # describe
end # describe
