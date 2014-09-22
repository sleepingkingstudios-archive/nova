# spec/presenters/features/page_presenter_spec.rb

# spec/presenters/feature_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/page_presenter'

RSpec.describe PagePresenter, :type => :decorator do
  let(:page)     { build(:page) }
  let(:instance) { described_class.new page }

  describe '#icon' do
    let(:expected) { %{<span class="fa fa-file-o"></span>} }

    it { expect(instance).to respond_to(:icon).with(0..1).arguments }

    it { expect(instance.icon).to be == expected }

    describe 'with options' do
      let(:expected) { %{<span class="fa fa-file-o fa-2x"></span>} }

      it { expect(instance.icon :scale => 2).to be == expected }      
    end # describe
  end # describe

  describe '#page' do
    it { expect(instance).to have_reader(:page).with(page) }
  end # describe
end # describe