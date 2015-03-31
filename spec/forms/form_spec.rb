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

  describe '#assign_attributes' do
    let(:resource) { double('resource', :assign_attributes => nil) }
    let(:params)   { { 'resource' => { 'evil' => 'malicious' } } }

    before(:each) { allow(instance).to receive(:resource_key).and_return('resource') }

    it { expect(instance).to respond_to(:assign_attributes).with(1).argument }

    it 'calls update_attributes on the resource with the permitted params' do
      expect(resource).to receive(:assign_attributes).with({})

      instance.assign_attributes ActionController::Parameters.new(params)
    end # it

    context 'with permitted params' do
      before(:each) { allow(instance).to receive(:permitted_params).and_return([:evil]) }

      it 'calls assign_attributes on the resource with the permitted params' do
        expect(resource).to receive(:assign_attributes).with(params.fetch('resource'))

        instance.assign_attributes ActionController::Parameters.new(params)
      end # it
    end # context
  end # describe

  describe '#resource_params' do
    let(:params) { ActionController::Parameters.new(instance.resource_key => { :evil => 'malicious' }) }

    it { expect(instance).to respond_to(:resource_params).with(1).argument }

    it { expect(instance.resource_params params).to be == {} }

    context 'with permitted params' do
      before(:each) { allow(instance).to receive(:permitted_params).and_return([:evil]) }

      it { expect(instance.resource_params params).to be == params.fetch(instance.resource_key) }
    end # context
  end # describe

  describe '#update_attributes' do
    let(:resource) { double('resource', :assign_attributes => nil, :save => nil) }
    let(:params)   { { 'resource' => { 'evil' => 'malicious' } } }

    before(:each) { allow(instance).to receive(:resource_key).and_return('resource') }

    it { expect(instance).to respond_to(:update).with(1).argument }

    it { expect(instance).to respond_to(:update_attributes).with(1).argument }

    it 'assigns attributes with the permitted params and saves the resource' do
      expect(resource).to receive(:assign_attributes).with({})
      expect(resource).to receive(:save).and_return(false)

      expect(instance.update_attributes ActionController::Parameters.new(params)).to be false
    end # it

    context 'with permitted params' do
      before(:each) { allow(instance).to receive(:permitted_params).and_return([:evil]) }

      it 'assigns attributes with the permitted params and saves the resource' do
        expect(resource).to receive(:assign_attributes).with(params.fetch('resource'))
        expect(resource).to receive(:save).and_return(true)

        expect(instance.update_attributes ActionController::Parameters.new(params)).to be true
      end # it
    end # context
  end # describe
end # describe
