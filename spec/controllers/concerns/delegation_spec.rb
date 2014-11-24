# spec/controllers/concerns/delegation_spec.rb

require 'rails_helper'

require 'sleeping_king_studios/tools/object_tools'

RSpec.describe Delegation, :type => :controller_concern do
  include SleepingKingStudios::Tools::ObjectTools

  shared_examples 'assigns @controller' do
    it 'assigns @controller' do
      instance.initialize_delegate

      expect(assigns.fetch(:delegate).controller).to be == instance
    end # it
  end # shared_examples

  shared_examples 'assigns @directories' do
    it 'assigns @directories' do
      instance.initialize_delegate

      expect(assigns.fetch(:delegate).directories).to be == []
    end # it

    context 'with many directories' do
      let(:directories) { %w(weapons swords japanese) }

      before(:each) { instance.directories = directories }

      it 'assigns @directories' do
        instance.initialize_delegate

        expect(assigns.fetch(:delegate).directories).to be == directories
      end # it
    end # context
  end # shared_examples

  let(:method_stubs) do
    Module.new do
      attr_accessor :resources, :resource, :directories, :current_user

      def params; end
    end # module
  end # let
  let(:instance) { Object.new.extend(method_stubs).extend(described_class) }

  let(:params) { {}.with_indifferent_access }
  let(:assigns) do
    instance.instance_variables.each.with_object({}) do |key, hsh|
      hsh[key.to_s.sub(/\A@/, '')] = instance.instance_variable_get(key)
    end.with_indifferent_access
  end # let

  before(:each) { allow(instance).to receive(:params).and_return(params) }

  describe '#initialize_delegate' do
    let(:directories) { [] }

    before(:each) do
      metaclass(instance).send :public, :initialize_delegate
    end # before each

    it { expect(instance).to respond_to(:initialize_delegate).with(0).arguments }

    context 'without a resource' do
      it 'assigns @delegate' do
        instance.initialize_delegate

        expect(assigns.fetch :delegate).to be_a ResourcesDelegate
      end # it

      expect_behavior 'assigns @controller'

      expect_behavior 'assigns @directories'
    end # context

    context 'with a resource' do
      let(:resource) { { :slug => 'katana' } }

      before(:each) do
        instance.resource = resource
      end # before each

      it 'assigns @delegate' do
        instance.initialize_delegate

        expect(assigns.fetch :delegate).to be_a ResourcesDelegate
        expect(assigns.fetch(:delegate).resource_class).to be == Hash
        expect(assigns.fetch(:delegate).resource).to be == resource
      end # it

      expect_behavior 'assigns @controller'

      expect_behavior 'assigns @directories'
    end # context

    context 'with an array of resources' do
      let(:resources) { %w(katana wakizashi tachi).map { |slug| { :slug => slug } } }

      before(:each) do
        instance.resources = resources
      end # before each

      it 'assigns @delegate' do
        instance.initialize_delegate

        expect(assigns.fetch :delegate).to be_a ResourcesDelegate
        expect(assigns.fetch(:delegate).resource_class).to be == Hash
        expect(assigns.fetch(:delegate).resources).to be == resources
      end # it

      expect_behavior 'assigns @controller'

      expect_behavior 'assigns @directories'
    end # context

    context 'with a resource class' do
      let(:resource_class) { Hash }

      before(:each) do
        allow(instance).to receive(:resource_class).and_return(resource_class)
      end # before each

      it 'assigns @delegate' do
        instance.initialize_delegate

        expect(assigns.fetch :delegate).to be_a ResourcesDelegate
        expect(assigns.fetch(:delegate).resource_class).to be == resource_class
      end # it

      expect_behavior 'assigns @controller'

      expect_behavior 'assigns @directories'
    end # context
  end # describe

  describe '#resource_class' do
    before(:each) do
      metaclass(instance).send :public, :resource_class
    end # before each

    it { expect(instance).to have_reader(:resource_class).with(nil) }
  end # describe
end # describe
