# spec/decorators/concerns/decorate_with_delegation_spec.rb

require 'rails_helper'

RSpec.describe DecorateWithDelegation, :type => :decorator do
  let(:described_class) { Class.new(Decorator).send(:include, super()) }
  let(:object)          { String.new }
  let(:instance)        { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(1).argument }
  end # describe

  it 'delegates to the object methods' do
    expect(instance).to have_reader(:length).with_value(object.length)
  end # it

  describe 'with custom delegate' do
    let(:described_class) do
      klass = super()
      klass.class_eval do
        private def __delegate__
          object.first
        end # method
      end # klass
      klass
    end # let
    let(:object) { %w(Spam Bacon Eggs) }

    it "delegates to the delegate's methods" do
      expect(instance).to have_reader(:length).with_value(object.first.length)
    end # it
  end # describe
end # describe
