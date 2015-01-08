# spec/forms/form_spec.rb

require 'rails_helper'

require 'form'

RSpec.describe Form, :type => :decorator do
  let(:resource) { Object.new }
  let(:instance) { described_class.new resource }

  ### Class Methods ###

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  ### Instance Methods ###

  describe '#resource_params' do
    let(:params) { ActionController::Parameters.new(instance.resource_key => { :evil => 'malicious' }) }

    it { expect(instance).to respond_to(:resource_params).with(1).argument }

    it { expect(instance.resource_params params).to be == {} }

    context 'with permitted params' do
      before(:each) { allow(instance).to receive(:permitted_params).and_return([:evil]) }

      it { expect(instance.resource_params params).to be == params.fetch(instance.resource_key) }
    end # context
  end # describe

  describe '#update' do
    let(:resource) { double('resource', :update => nil) }
    let(:params)   { { 'resource' => { 'evil' => 'malicious' } } }

    before(:each) { allow(instance).to receive(:resource_key).and_return('resource') }

    it { expect(instance).to respond_to(:update).with(1).argument }

    it 'calls update on the resource with the permitted params' do
      expect(resource).to receive(:update_attributes).with({})

      instance.update ActionController::Parameters.new(params)
    end # it

    context 'with permitted params' do
      before(:each) { allow(instance).to receive(:permitted_params).and_return([:evil]) }

      it 'calls update on the resource with the permitted params' do
        expect(resource).to receive(:update_attributes).with(params.fetch('resource'))

        instance.update ActionController::Parameters.new(params)
      end # it
    end # context
  end # describe
end # describe
