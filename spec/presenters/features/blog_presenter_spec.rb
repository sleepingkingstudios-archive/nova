# spec/presenters/features/blog_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/blog_presenter'

RSpec.describe BlogPresenter, :type => :decorator do
  let(:attributes) { {} }
  let(:blog)       { build(:blog, attributes) }
  let(:instance)   { described_class.new blog }

  describe '#blog' do
    it { expect(instance).to have_reader(:blog).with(blog) }
  end # describe

  describe '#icon' do
    let(:expected) { %{<span class="fa fa-newspaper-o"></span>} }

    it { expect(instance).to respond_to(:icon).with(0..1).arguments }

    it { expect(instance.icon).to be == expected }

    describe 'with options' do
      let(:expected) { %{<span class="fa fa-newspaper-o fa-2x"></span>} }

      it { expect(instance.icon :scale => 2).to be == expected }
    end # describe
  end # describe
end # describe
