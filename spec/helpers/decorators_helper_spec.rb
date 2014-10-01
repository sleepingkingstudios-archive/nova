# spec/helpers/decorators_helper_spec.rb

require 'rails_helper'

RSpec.describe DecoratorsHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  describe '#decorate' do
    shared_context 'with a custom decorator', :decorator => :custom do
      let(:custom_decorator_type)  { :HashDefenestrator }
      let(:custom_decorator_class) { Class.new(decorator_class) }

      before(:each) do
        Object.const_set custom_decorator_type, custom_decorator_class
      end # before each

      after(:each) do
        Object.send :remove_const, custom_decorator_type if Object.const_defined?(custom_decorator_type)
      end # after each
    end # shared_context

    shared_context 'with a custom plural decorator', :decorator => :plural do
      let(:custom_decorator_type)  { :HashesDefenestrator }
      let(:custom_decorator_class) { Class.new(decorator_class) }

      before(:each) do
        Object.const_set custom_decorator_type, custom_decorator_class
      end # before each

      after(:each) do
        Object.send :remove_const, custom_decorator_type if Object.const_defined?(custom_decorator_type)
      end # after each
    end # shared_context

    shared_context 'with a custom object', :object => :custom do
      let(:custom_object_type)  { :ExtendedHash }
      let(:custom_object_class) { Class.new(Hash) }

      before(:each) do
        Object.const_set custom_object_type, custom_object_class
      end # before each

      after(:each) do
        Object.send :remove_const, custom_object_type if Object.const_defined?(custom_object_type)
      end # after each
    end # shared_context

    let(:decorator_type) { :Defenestrator }
    let(:decorator_class) do
      Class.new do
        def initialize object
          @object = object
        end # method initialize

        attr_reader :object
      end # class
    end # let

    before(:each) do
      Object.const_set decorator_type, decorator_class
    end # before each

    after(:each) do
      Object.send :remove_const, decorator_type if Object.const_defined?(decorator_type)
    end # after each

    it { expect(instance).to respond_to(:decorate).with(2..3).arguments }

    describe 'with an object' do
      let(:object) { Object.new }

      it { expect(instance.decorate object, decorator_type).to be_a decorator_class }

      it 'decorates the object' do
        expect(instance.decorate(object, decorator_type).object).to be object
      end # it

      describe 'with a custom decorator', :decorator => :custom do
        let(:object) { Hash.new }

        it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }

        describe 'with a custom object', :object => :custom do
          let(:object) { custom_object_class.new }

          it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }
        end # describe
      end # describe

      describe 'with a custom plural decorator', :decorator => :plural do
        let(:object) { Hash.new }

        it { expect(instance.decorate object, decorator_type, :plural => true).to be_a custom_decorator_class }
      end # describe

      describe 'with a default decorator' do
        let(:decorator_type) { :RubyDefenestrator }

        it { expect(instance.decorate object, :Defenestrator, :default => :RubyDefenestrator).to be_a decorator_class }

        it 'decorates the object' do
          expect(instance.decorate(object, :Defenestrator, :default => :RubyDefenestrator).object).to be object
        end # it
      end # describe
    end # describe

    describe 'with a string' do
      let(:object) { 'Object' }

      it { expect(instance.decorate object, decorator_type).to be_a decorator_class }

      it 'decorates the object' do
        expect(instance.decorate(object, decorator_type).object).to be object.to_s.classify.constantize
      end # it

      describe 'with a custom decorator', :decorator => :custom do
        let(:object) { 'Hash' }

        it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }

        describe 'with a custom object', :object => :custom do
          let(:object) { custom_object_class.name }

          it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }
        end # describe
      end # describe

      describe 'with a custom plural decorator', :decorator => :plural do
        let(:object) { 'Hash' }

        it { expect(instance.decorate object, decorator_type, :plural => true).to be_a custom_decorator_class }
      end # describe
    end # describe

    describe 'with a symbol' do
      let(:object) { :object }

      it { expect(instance.decorate object, decorator_type).to be_a decorator_class }

      it 'decorates the object' do
        expect(instance.decorate(object, decorator_type).object).to be object.to_s.classify.constantize
      end # it

      describe 'with a custom decorator', :decorator => :custom do
        let(:object) { :hash }

        it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }

        describe 'with a custom object', :object => :custom do
          let(:object) { custom_object_type.to_s.underscore.intern }

          it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }
        end # describe
      end # describe

      describe 'with a custom plural decorator', :decorator => :plural do
        let(:object) { :hash }

        it { expect(instance.decorate object, decorator_type, :plural => true).to be_a custom_decorator_class }
      end # describe
    end # describe

    describe 'with an array of objects' do
      let(:objects) { Array.new(3).map { Object.new } }

      it { expect(instance.decorate objects, decorator_type).to be_a decorator_class }

      it 'decorates the object' do
        expect(instance.decorate(objects, decorator_type).object).to be objects
      end # it

      describe 'with a custom decorator', :decorator => :custom do
        let(:object) { Array.new(3).map { Hash.new } }

        it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }

        describe 'with a custom object', :object => :custom do
          let(:object) { Array.new(3).map { custom_object_class.new } }

          it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }
        end # describe
      end # describe

      describe 'with a custom plural decorator', :decorator => :plural do
        let(:object) { Array.new(3).map { Hash.new } }

        it { expect(instance.decorate object, decorator_type, :plural => true).to be_a custom_decorator_class }
      end # describe
    end # describe

    describe 'with a class' do
      let(:object) { Object }

      it { expect(instance.decorate object, decorator_type).to be_a decorator_class }

      it 'decorates the object' do
        expect(instance.decorate(object, decorator_type).object).to be object
      end # it

      describe 'with a custom decorator', :decorator => :custom do
        let(:object) { Hash }

        it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }

        describe 'with a custom object', :object => :custom do
          let(:object) { custom_object_class }

          it { expect(instance.decorate object, decorator_type).to be_a custom_decorator_class }
        end # describe
      end # describe

      describe 'with a custom plural decorator', :decorator => :plural do
        let(:object) { Hash.new }

        it { expect(instance.decorate object, decorator_type, :plural => true).to be_a custom_decorator_class }
      end # describe
    end # describe
  end # describe

  describe '#present' do
    let(:object) { Object.new }

    it { expect(instance).to respond_to(:present).with(1).argument }

    it { expect(instance.present object).to be_a Presenter }

    it 'decorates the object' do
      expect(instance.present(object).object).to be object
    end # it

    describe 'with a custom presenter' do
      let(:object) { Feature.new }

      it { expect(instance.present object).to be_a FeaturePresenter }

      it 'decorates the object' do
        expect(instance.present(object).object).to be object
      end # it
    end # describe

    describe 'with a custom presenter for superclass' do
      let(:subclass) { Class.new(Feature) }
      let(:object)   { subclass.new }

      before(:each)  { allow(subclass).to receive(:name).and_return("AnonymousSubclass") }

      it { expect(instance.present object).to be_a FeaturePresenter }

      it 'decorates the object' do
        expect(instance.present(object).object).to be object
      end # it
    end # describe
  end # describe
end # describe
