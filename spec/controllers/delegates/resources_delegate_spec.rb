# spec/controllers/delegates/resources_delegate_spec.rb

require 'rails_helper'

require 'delegates/resources_delegate'

RSpec.describe ResourcesDelegate, :type => :decorator do
  let(:object)     { Feature.new }
  let(:instance)   { described_class.new object }
  let(:controller) { double('controller', :render => nil) }
  
  def assigns
    controller.instance_variables.each.with_object({}) do |key, hsh|
      hsh[key.to_s.sub(/\A@/, '')] = controller.instance_variable_get(key)
    end.with_indifferent_access
  end # method assigns

  shared_context 'with an array of objects', :object => :array do
    let(:object) { Array.new(3).map { Object.new } }
  end # shared_context

  shared_context 'with a class object', :object => :class do
    let(:object) { String }
  end # shared_context

  ### Class Methods ###

  describe '::new' do
    it { expect(described_class).to construct.with(1).arguments }
  end # describe

  ### Instance Methods ###

  describe '#assign' do
    before(:each) { instance.controller = controller }

    it { expect(instance).to respond_to(:assign).with(2).arguments }

    it 'changes the assigned variables in the controller' do
      expect { instance.assign :user, 'Alan Bradley' }.to change { assigns[:user] }.to('Alan Bradley')
    end # it
  end # describe

  describe '#build_resource' do
    it { expect(instance).to respond_to(:build_resource).with(1).argument }

    it 'creates the specified resource' do
      expect(instance.build_resource nil).to be_a Feature
    end # expect

    it 'caches the document in @resource' do
      object = instance.build_resource nil

      expect(instance.resource).to be == object
      expect(instance.resources).to be nil
    end # it
  end # describe

  describe '#build_resource_params' do
    let(:params) { ActionController::Parameters.new({ :evil => 'malicious' }) }

    it { expect(instance).to respond_to(:build_resource_params).with(1).argument }

    it { expect(instance.build_resource_params params).to be == {} }
  end # describe

  describe '#controller' do
    it { expect(instance).to have_property(:controller) }

    it { expect(instance.controller).to be nil }
  end # describe

  describe '#load_resources' do
    let(:documents) { Array.new(3).map { double('document') } }

    before(:each) do
      allow(Feature).to receive(:all).and_return(documents)
    end # before each

    it { expect(instance).to respond_to(:load_resources).with(0).arguments }

    it 'returns the specified resources' do
      expect(instance.load_resources).to be == documents
    end # it

    it 'caches the documents in @resources' do
      instance.load_resources

      expect(instance.resource).to be nil
      expect(instance.resources).to be == documents
    end # it
  end # describe

  describe '#resource' do
    it { expect(instance).to have_reader(:resource).with(object) }

    context 'with an array of objects', :object => :array do
      it { expect(instance.resource).to be nil }
    end # context

    context 'with a class object', :object => :class do
      it { expect(instance.resource).to be nil }
    end # context
  end # describe

  describe '#resources' do
    it { expect(instance).to have_reader(:resources).with(nil) }

    context 'with an array of objects', :object => :array do
      it { expect(instance.resources).to be == object }
    end # context

    context 'with a class object', :object => :class do
      it { expect(instance.resources).to be nil }
    end # context
  end # describe

  describe '#resource_class' do
    it { expect(instance).to have_reader(:resource_class).with(object.class) }

    context 'with an array of objects' do
      let(:object) { Array.new(3).map { Object.new } }

      it { expect(instance.resource_class).to be == object.first.class }
    end # context

    context 'with a class object' do
      let(:object) { String }

      it { expect(instance.resource_class).to be == object }
    end # context
  end # describe

  describe '#resource_name' do
    it { expect(instance).to have_reader(:resource_name).with(object.class.name.tableize) }

    context 'with an array of objects' do
      let(:object) { Array.new(3).map { Object.new } }

      it { expect(instance.resource_name).to be == object.first.class.name.tableize }
    end # context

    context 'with a class object' do
      let(:object) { String }

      it { expect(instance.resource_name).to be == object.name.tableize }
    end # context
  end # describe

  describe '#resource_params' do
    let(:params) { ActionController::Parameters.new({ :evil => 'malicious' }) }

    it { expect(instance).to respond_to(:resource_params).with(1).argument }

    it { expect(instance.resource_params params).to be == {} }
  end # describe

  ### Actions ###

  describe '#index' do
    let(:documents)  { Array.new(3).map { double('document') } }
    let(:controller) { double('controller', :render => nil) }
    let(:object)     { Feature }
    let(:request)    { double('request') }

    before(:each) do
      allow(object).to receive(:all).and_return(documents)

      instance.controller = controller
    end # before each

    it { expect(instance).to respond_to(:index).with(1).arguments }

    it 'assigns resources' do
      instance.index request

      expect(assigns.fetch(:resources)).to be == documents
    end # it

    it 'renders the index template' do
      expect(controller).to receive(:render).with(instance.index_template_path)

      instance.index request
    end # it
  end # describe

  describe '#new' do
    let(:controller) { double('controller', :render => nil) }
    let(:object)     { Feature }
    let(:request)    { double('request', :params => ActionController::Parameters.new({})) }

    before(:each) do
      instance.controller = controller
    end # before each

    it { expect(instance).to respond_to(:new).with(1).arguments }

    it 'assigns resource' do
      instance.new request

      expect(assigns.fetch(:resource)).to be_a Feature
    end # it

    it 'renders the new template' do
      expect(controller).to receive(:render).with(instance.new_template_path)

      instance.new request
    end # it
  end # describe

  ### Partial Methods ###

  describe '#index_template_path' do
    it { expect(instance).to have_reader(:index_template_path).with('admin/features/index') }
  end # describe

  describe '#new_template_path' do
    it { expect(instance).to have_reader(:new_template_path).with('admin/features/new') }
  end # describe

  ### Routing Methods ###

  describe '#resource_path' do
    it { expect(instance).to have_reader(:resource_path).with("features/#{object.id}") }
  end # describe

  describe '#resources_path' do
    it { expect(instance).to have_reader(:resources_path).with('features') }
  end # describe
end # describe
