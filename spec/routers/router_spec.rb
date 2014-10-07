# spec/routers/router_spec.rb

require 'rails_helper'

require 'routers/router'

RSpec.describe Router, :type => :decorator do
  shared_context 'with routing parameters' do
    let(:search)  { 'weapons/swords/japanese/tachi'.split('/') }
    let(:found) do
      search[0..1].map { |slug| double('directory', :slug => slug) }
    end # let
    let(:missing) { search[2..3] }
  end # shared_context

  shared_examples 'assigns routing properties' do
    def handle_resources_exceptions &block
      yield
    rescue Appleseed::ResourcesNotFoundError
    end # method handle_resources_exceptions

    it 'sets the #search property' do
      expect { handle_resources_exceptions { perform_action } }.to change(instance, :search).to(search)
    end # it

    it 'sets the found property' do
      expect { handle_resources_exceptions { perform_action } }.to change(instance, :found).to(found)
    end # it

    it 'sets the missing property' do
      expect { handle_resources_exceptions { perform_action } }.to change(instance, :missing).to(missing)
    end # it
  end # shared_examples

  let(:object)   { Object.new }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(1).arguments }
  end # describe

  describe '#found' do
    it { expect(instance).to have_reader(:found) }
  end # describe

  describe '#missing' do
    it { expect(instance).to have_reader(:missing) }
  end # describe

  describe '#object' do
    it { expect(instance).to have_reader(:object).with(object) }
  end # describe

  describe '#route_to' do
    include_context 'with routing parameters'

    def perform_action
      instance.route_to search, found, missing
    end # perform_action

    it { expect(instance).to respond_to(:route_to).with(3).arguments }

    it { expect(perform_action).to be nil }

    expect_behavior 'assigns routing properties'
  end # describe

  describe '#route_to!' do
    include_context 'with routing parameters'

    def perform_action
      instance.route_to! search, found, missing
    end # perform_action

    it { expect(instance).to respond_to(:route_to!).with(3).arguments }

    it 'raises an error' do
      expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
        expect(exception.search).to  be == search
        expect(exception.found).to   be == found
        expect(exception.missing).to be == missing
      end # raise_error
    end # it

    expect_behavior 'assigns routing properties'
  end # describe

  describe '#search' do
    it { expect(instance).to have_reader(:search) }
  end # describe
end # describe
