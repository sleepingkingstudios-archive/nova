# spec/decorators/resource_decorator_spec.rb

require 'rails_helper'

RSpec.describe ResourceDecorator, :type => :decorator do
  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  describe 'with a resource class' do
    let(:object_class) { Directory }
    let(:instance)     { described_class.new object_class }

    describe '#object' do
      it { expect(instance.object).to be nil }
    end # describe

    describe '#object_class' do
      it { expect(instance.object_class).to be object_class }
    end # describe

    describe '#resource' do
      it { expect(instance).to have_reader(:resource).with_value(nil) }
    end # describe

    describe '#resource_class' do
      it { expect(instance).to have_reader(:resource_class).with_value(object_class) }
    end # describe

    describe '#resource_key' do
      it { expect(instance).to have_reader(:resource_key).with_value(object_class.to_s.underscore) }
    end # describe

    describe '#resource_name' do
      it { expect(instance).to have_reader(:resource_name).with_value(object_class.to_s.tableize) }
    end # describe
  end # describe

  describe 'with a resource instance' do
    let(:object)   { Directory.new }
    let(:instance) { described_class.new object }

    describe '#object' do
      it { expect(instance.object).to be object }
    end # describe

    describe '#object_class' do
      it { expect(instance.object_class).to be object.class }
    end # describe

    describe '#resource' do
      it { expect(instance).to have_reader(:resource).with_value(object) }
    end # describe

    describe '#resource_class' do
      it { expect(instance).to have_reader(:resource_class).with_value(object.class) }
    end # describe

    describe '#resource_key' do
      it { expect(instance).to have_reader(:resource_key).with_value(object.class.to_s.underscore) }
    end # describe

    describe '#resource_name' do
      it { expect(instance).to have_reader(:resource_name).with_value(object.class.to_s.tableize) }
    end # describe
  end # describe
end # describe
