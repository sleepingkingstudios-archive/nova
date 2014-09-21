# spec/presenters/feature_presenter_spec.rb

require 'rails_helper'

require 'presenters/feature_presenter'

RSpec.describe FeaturePresenter, :type => :decorator do
  let(:feature)  { build(:feature) }
  let(:instance) { described_class.new feature }

  describe '#feature' do
    it { expect(instance).to have_reader(:feature).with(feature) }
  end # describe
end # describe
