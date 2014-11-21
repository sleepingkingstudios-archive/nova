# spec/presenters/features/directory_feature_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/directory_feature_presenter'

RSpec.describe DirectoryFeaturePresenter, :type => :decorator do
  let(:attributes) { {} }
  let(:feature)    { build(:directory_feature, attributes) }
  let(:instance)   { described_class.new feature }

  describe '#directory' do
    it { expect(instance).to have_reader(:directory) }

    context 'without a directory' do
      let(:attributes) { super().merge :directory => nil }

      it { expect(instance.directory).to be nil }
    end # context

    context 'with a directory' do
      let(:directory)  { create(:directory) }
      let(:attributes) { super().merge :directory => directory }

      it { expect(instance.directory).to be == directory }
    end # context
  end # describe
end # describe
