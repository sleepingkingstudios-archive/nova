# spec/content_builders/text_content_builder_spec.rb

require 'rails_helper'

require 'content_builders/text_content_builder'

RSpec.describe TextContentBuilder, :type => :decorator do
  shared_context 'with a class object', :object => :class do
    let(:object) { TextContent }
  end # shared_context

  let(:object)   { build(:text_content) }
  let(:instance) { described_class.new object }

  describe '#content_params' do
    let(:attributes) { attributes_for(:text_content).with_indifferent_access }
    let(:params)     { ActionController::Parameters.new(attributes.merge :evil => 'malicious') }

    it { expect(instance.content_params params).to be == attributes }
  end # describe

  describe '#update_content' do
    let(:params) { ActionController::Parameters.new(:text_content => 'This content is deceased! It is an ex-content!') }

    it 'updates the content' do
      instance.update_content params

      expect(instance.content.text_content).to be == params[:text_content]
    end # it
  end # describe
end # describe
