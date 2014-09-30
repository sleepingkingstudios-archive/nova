# spec/controllers/delegates/features/pages_delegate_spec.rb

require 'rails_helper'

require 'delegates/features/pages_delegate'

RSpec.describe PagesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  let(:object)   { build(:page) }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be Page
      end # it
    end # it
  end # describe

  ### Instance Methods ###

  describe '#build_resource' do
    let(:params) { ActionController::Parameters.new({}) }

    it { expect(instance).to respond_to(:build_resource).with(1).argument }

    it 'creates the specified resource' do
      expect(instance.build_resource params).to be_a Page
    end # expect

    it 'creates an embedded content' do
      object = instance.build_resource params

      expect(instance.resource).to be == object
      expect(instance.resource.content).to be_a Content
    end # it
  end # describe

  describe '#content_params' do
    let(:content_params) { { 'text_content' => 'It was a dark and stormy night...' } }
    let(:params)         { { :page => { :content => content_params } } }

    it { expect(instance).to respond_to(:content_params).with(1).arguments }

    it { expect(instance.content_params params).to be == content_params }
  end # describe

  ### Actions ###

  describe '#new', :controller => true do
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    it 'assigns @resource' do
      instance.new request

      expect(assigns.fetch(:resource)).to be_a Page
      expect(assigns.fetch(:resource).content).to be_a Content
    end # it
  end # describe
end # describe
