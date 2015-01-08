# spec/decorators/decorator_spec.rb

require 'rails_helper'

RSpec.describe Decorator, :type => :decorator do
  let(:object)   { String.new }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  describe '#object' do
    it { expect(instance).to have_reader(:object).with_value(object) }
  end # describe

  describe '#object_class' do
    it { expect(instance).to have_reader(:object_class).with_value(object.class) }
  end # describe
end # describe
