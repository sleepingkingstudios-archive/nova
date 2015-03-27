# spec/helpers/icons_helper_spec.rb

require 'rails_helper'

RSpec.describe IconsHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  describe '#edit_icon' do
    let(:icon) { %{<span class="fa fa-edit"></span>} }

    it { expect(instance).to respond_to(:edit_icon).with(0..1).arguments }

    it { expect(instance.edit_icon).to be == icon }
  end # describe

  describe '#icon' do
    it { expect(instance).to respond_to(:icon).with(1..2).arguments }

    describe 'with an icon name' do
      let(:icon) { %{<span class="fa fa-user"></span>} }

      it { expect(instance.icon :user).to be == icon }

      describe 'with a border option' do
        let(:icon) { %{<span class="fa fa-user fa-border"></span>} }

        it { expect(instance.icon :user, :border => true).to be == icon }
      end # describe

      describe 'with a fixed-width option' do
        let(:icon) { %{<span class="fa fa-user fa-fw"></span>} }

        it { expect(instance.icon :user, :width => :fixed).to be == icon }
      end # describe

      describe 'with a flip option' do
        let(:icon) { %{<span class="fa fa-user fa-flip-horizontal"></span>} }

        it { expect(instance.icon :user, :flip => :horizontal).to be == icon }
      end # describe

      describe 'with a pull option' do
        let(:icon) { %{<span class="fa fa-user pull-left"></span>} }

        it { expect(instance.icon :user, :pull => :left).to be == icon }
      end # describe

      describe 'with a rotate option' do
        let(:icon) { %{<span class="fa fa-user fa-rotate-90"></span>} }

        it { expect(instance.icon :user, :rotate => 90).to be == icon }
      end # describe

      describe 'with a scale option' do
        let(:icon) { %{<span class="fa fa-user fa-2x"></span>} }

        it { expect(instance.icon :user, :scale => 2).to be == icon }
      end # describe

      describe 'with a spin option' do
        let(:icon) { %{<span class="fa fa-user fa-spin"></span>} }

        it { expect(instance.icon :user, :spin => true).to be == icon }
      end # describe

      describe 'with custom classes' do
        let(:icon) { %{<span class="fa fa-bomb text-danger"></span>} }

        it { expect(instance.icon :bomb, :class => 'text-danger').to be == icon }
      end # describe
    end # describe

    describe 'with a multipart icon name' do
      let(:icon) { %{<span class="fa fa-paper-plane"></span>} }

      it { expect(instance.icon :paper_plane).to be == icon }
    end # describe
  end # describe
end # describe
