# spec/helpers/icons_helper_spec.rb

require 'rails_helper'

RSpec.describe IconsHelper, :type => :helper do
  let(:instance) { Object.new.extend described_class }

  def self.wrap_translations hsh
    around(:each) do |example|
      i18n = I18n.backend

      i18n.send(:init_translations) unless i18n.initialized?

      translations = i18n.instance_variable_get(:@translations).deep_dup

      i18n.store_translations(I18n.locale, hsh)

      example.call

      i18n.instance_variable_set(:@translations, translations)
    end # around
  end # class method wrap_translations

  describe '#icon' do
    it { expect(instance).to respond_to(:icon).with(1..2).arguments }

    describe 'with an empty icon name' do
      let(:icon) { %{<span class="fa fa-bug" style="color:#F00;"></span>} }

      it { expect(instance.icon '').to be == icon }
    end # describe

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

  describe '#icon_name' do
    it { expect(instance).to respond_to(:icon_name).with(1..2, :default).arguments }

    describe 'with an action' do
      it { expect(instance.icon_name 'defenestrate').to be nil }

      describe 'with a default value' do
        let(:default) { 'boot' }

        it { expect(instance.icon_name 'defenestrate', :default => default).to be == default }
      end # describe

      describe 'with a defined icon name for the action' do
        def self.defined; 'broken-window'; end

        let(:defined) { self.class.defined }

        wrap_translations({ :icons => { :defenestrate => defined } })

        it { expect(instance.icon_name 'defenestrate').to be == defined }

        describe 'with a default value' do
          let(:default) { 'boot' }

          it { expect(instance.icon_name 'defenestrate', :default => default).to be == defined }
        end # describe
      end # it
    end # describe

    describe 'with an action and a resource' do
      it { expect(instance.icon_name 'cross', 'streams').to be nil }

      describe 'with a default value' do
        let(:default) { "dont-cross-the-streams" }

        it { expect(instance.icon_name 'cross', 'streams', :default => default).to be == default }
      end # describe

      describe 'with a defined icon name for the action' do
        def self.defined; 'died-of-dysentery'; end

        let(:defined) { self.class.defined }

        wrap_translations({ :icons => { :cross => defined } })

        it { expect(instance.icon_name 'cross', 'streams').to be == defined }

        describe 'with a default value' do
          let(:default) { "dont-cross-the-streams" }

          it { expect(instance.icon_name 'cross', 'streams', :default => default).to be == defined }
        end # describe
      end # describe

      describe 'with a defined icon name for the action and resource' do
        def self.defined; 'total-protonic-reversal'; end

        let(:defined) { self.class.defined }

        wrap_translations({
          :features => {
            :streams => {
              :icons => {
                :cross => defined
              } # end hash
            } # end hash
          }, # end hash
          :icons => {
            :cross => 'dont-cross-the-streams'
          } # end hash
        }) # wrap_translations

        it { expect(instance.icon_name 'cross', 'streams').to be == defined }

        describe 'with a default value' do
          let(:default) { "dont-cross-the-streams" }

          it { expect(instance.icon_name 'cross', 'streams', :default => default).to be == defined }
        end # describe
      end # describe
    end # describe
  end # describe

  describe 'should generate icon helpers' do
    let(:icon) { %{<span class="fa fa-bomb"></span>} }

    describe 'with an undefined icon helper for an action' do
      before(:each) { allow(instance).to receive(:icon_name).with(:rm, nil).and_return('bomb') }

      after(:each) { described_class.send :undef_method, :rm_icon }

      it 'should generate an icon helper' do
        expect(instance).not_to respond_to(:rm_icon)

        expect(instance.rm_icon).to be == icon

        expect(instance).to respond_to(:rm_icon)
      end # it
    end # describe

    describe 'with an undefined icon helper for an action and resource' do
      before(:each) { allow(instance).to receive(:icon_name).with(:rm, :rf).and_return('bomb') }

      after(:each) { described_class.send :undef_method, :rm_rf_icon }

      it 'should generate an icon helper' do
        expect(instance).not_to respond_to(:rm_rf_icon)

        expect(instance.rm_rf_icon).to be == icon

        expect(instance).to respond_to(:rm_rf_icon)
      end # it
    end # describe
  end # describe
end # describe
