# spec/models/features/contents/text_content_spec.rb

require 'rails_helper'

RSpec.describe TextContent, :type => :model do
  include Spec::Contexts::Models::ContentContexts

  let(:attributes) { attributes_for(:text_content) }
  let(:instance)   { described_class.new attributes }

  it { expect(Content.content_types.fetch(:text)).to be == described_class }

  ### Class Methods ###

  describe '#content_type_name' do
    it { expect(described_class).to have_reader(:content_type_name).with('Plain Text') }
  end # describe

  ### Attributes ###

  describe '#text_content' do
    it { expect(instance).to have_property(:text_content) }
  end # describe

  ### Validation ###

  describe 'validation' do
    wrap_context 'with a container' do
      it { expect(instance).to be_valid }
    end # context

    describe 'text_content must be present' do
      let(:attributes) { super().merge :text_content => nil }

      it { expect(instance).to have_errors.on(:text_content).with_message("can't be blank") }
    end # describe
  end # describe
end # describe
