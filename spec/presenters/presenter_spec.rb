# spec/presenters/presenter_spec.rb

require 'rails_helper'

require 'presenters/presenter'

RSpec.describe Presenter, :type => :decorator do
  let(:object)   { Object.new }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(1).arguments }
  end # describe

  describe '#object' do
    it { expect(instance).to have_reader(:object).with(object) }
  end # describe

  describe '#root_path' do
    it { expect(instance).to have_reader(:root_path).with('/') }
  end # describe
end # describe
