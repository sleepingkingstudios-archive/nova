# spec/content_builders/content_builder_spec.rb

require 'rails_helper'

require 'content_builders/content_builder'

RSpec.describe ContentBuilder, :type => :decorator do
  shared_context 'with a class object' do
    let(:object) { Content }
  end # shared_context

  let(:object)   { build(:content) }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(1).arguments }
  end # describe

  describe '#build_content' do
    include_examples 'with a class object'

    let(:params) { ActionController::Parameters.new(:evil => 'malicious') }

    it { expect(instance).to respond_to(:build_content).with(1).argument }

    it 'builds a new content' do
      expect { instance.build_content params }.to change(instance, :content).to be_a Content
    end # it
  end # describe

  describe '#build_content_params' do
    let(:params) { ActionController::Parameters.new(:evil => 'malicious') }

    it { expect(instance).to respond_to(:build_content_params).with(1).argument }

    it { expect(instance.build_content_params params).to be == {} }
  end # describe

  describe '#content' do
    it { expect(instance).to have_reader(:content).with(object) }

    wrap_context 'with a class object' do
      it { expect(instance.content).to be nil }
    end # context
  end # describe

  describe '#content_class' do
    it { expect(instance).to have_reader(:content_class).with(object.class) }

    wrap_context 'with a class object' do
      it { expect(instance.content_class).to be object }
    end # context
  end # describe

  describe '#content_params' do
    let(:params) { ActionController::Parameters.new(:evil => 'malicious') }

    it { expect(instance).to respond_to(:content_params).with(1).argument }

    it { expect(instance.content_params params).to be == {} }
  end # describe

  describe '#update_content' do
    it { expect(instance).to respond_to(:update_content).with(1).argument }
  end # describe

  describe '#update_content_params' do
    let(:params) { ActionController::Parameters.new(:evil => 'malicious') }

    it { expect(instance).to respond_to(:update_content_params).with(1).argument }

    it { expect(instance.update_content_params params).to be == {} }
  end # describe
end # describe
