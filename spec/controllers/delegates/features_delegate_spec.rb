# spec/controllers/delegates/features_delegate_spec.rb

require 'rails_helper'

require 'delegates/features_delegate'

RSpec.describe FeaturesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  shared_context 'with request params' do
    let(:params) do
      ActionController::Parameters.new(
        :feature => {
          :title => 'Some Title',
          :slug  => 'Some Slug',
          :evil  => 'malicious'
        } # end hash
      ) # end hash
    end # let
  end # shared_context

  shared_examples 'sanitizes feature attributes' do
    it 'whitelists feature attributes' do
      %w(title slug).each do |attribute|
        expect(sanitized[attribute]).to be == params.fetch(:feature).fetch(attribute)
      end # each
    end # it

    it 'excludes unrecognized attributes' do
      expect(sanitized).not_to have_key 'evil'
    end # it
  end # shared_examples

  let(:instance) { described_class.new }

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be Feature
      end # it
    end # it
  end # describe

  ### Instance Methods ###

  describe '#build_resource_params' do
    include_examples 'with request params'

    let(:sanitized) { instance.build_resource_params params }

    expect_behavior 'sanitizes feature attributes'
  end # describe

  describe '#resource_params' do
    include_examples 'with request params'

    let(:sanitized) { instance.resource_params params }

    expect_behavior 'sanitizes feature attributes'
  end # describe

  ### Partial Methods ###

  describe '#index_template_path' do
    it { expect(instance).to have_reader(:index_template_path).with('admin/features/features/index') }
  end # describe

  describe '#new_template_path' do
    it { expect(instance).to have_reader(:new_template_path).with('admin/features/features/new') }
  end # describe

  describe '#show_template_path' do
    it { expect(instance).to have_reader(:show_template_path).with('features/features/show') }
  end # describe

  describe '#edit_template_path' do
    it { expect(instance).to have_reader(:edit_template_path).with('admin/features/features/edit') }
  end # describe
end # describe
