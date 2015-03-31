# spec/decorators/concerns/decorate_class_or_instance_spec.rb

require 'rails_helper'

RSpec.describe DecorateClassOrInstance, :type => :decorator do
  let(:described_class) { Class.new(Decorator).send(:include, super()) }

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  describe 'with a class' do
    let(:object_class) { Hash }
    let(:instance)     { described_class.new object_class }

    describe '#object' do
      it { expect(instance.object).to be nil }
    end # describe

    describe '#object_class' do
      it { expect(instance.object_class).to be object_class }
    end # describe
  end # describe

  describe 'with an instance' do
    let(:object)   { Hash.new }
    let(:instance) { described_class.new object }

    describe '#object' do
      it { expect(instance.object).to be object }
    end # describe

    describe '#object_class' do
      it { expect(instance.object_class).to be object.class }
    end # describe
  end # describe
end # describe
