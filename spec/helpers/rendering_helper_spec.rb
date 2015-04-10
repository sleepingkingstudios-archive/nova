# spec/helpers/rendering_helper_spec.rb

require 'rails_helper'

RSpec.describe RenderingHelper, :type => :helper do
  let(:instance) do
    double('helper', :render => nil).extend described_class
  end # let

  describe '#render_component' do
    it { expect(instance).to respond_to(:render_component).with(1..2).arguments.and_a_block }

    describe 'with a component name' do
      let(:component_name) { 'common/components/self_sealing_stem_bolt' }

      it 'should render the component as a partial' do
        expect(instance).to receive(:render) do |options|
          expect(options.fetch(:partial)).to be == component_name
        end # expect

        instance.render_component component_name
      end # it

      describe 'with local variables' do
        let(:locals) { { :diameter => '1.15cm', :tensile_strength => '10kN' } }

        it 'should render the component as a partial' do
          expect(instance).to receive(:render) do |options|
            expect(options.fetch(:partial)).to be == component_name
            expect(options.fetch(:locals)).to be == locals
          end # expect

          instance.render_component component_name, locals
        end # it
      end # describe
    end # describe

    describe 'with a component_name and a block' do
      let(:component_name) { 'common/components/self_sealing_stem_bolt' }
      let(:component_block) do
        ->() { render :text => 'This is a great deal!' }
      end # let

      it 'should render the component as a layout' do
        expect(instance).to receive(:render) do |options, &block|
          expect(options.fetch(:layout)).to be == component_name

          expect(block).to be == component_block
        end # expect

        instance.render_component component_name, &component_block
      end # it

      describe 'with local variables' do
        let(:locals) { { :diameter => '1.15cm', :tensile_strength => '10kN' } }

        it 'should render the component as a layout' do
          expect(instance).to receive(:render) do |options, &block|
            expect(options.fetch(:layout)).to be == component_name
            expect(options.fetch(:locals)).to be == locals

            expect(block).to be == component_block
          end # expect

          instance.render_component component_name, locals, &component_block
        end # it
      end # describe
    end # describe
  end # describe
end # describe
