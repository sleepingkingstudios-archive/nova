# spec/controllers/delegates/features/directory_features_delegate_spec.rb

require 'rails_helper'

require 'delegates/features/directory_features_delegate'

RSpec.describe DirectoryFeaturesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  let(:object)   { build(:directory_feature) }
  let(:instance) { described_class.new object }

  shared_context 'with request params' do
    let(:params) do
      ActionController::Parameters.new(
        :directory_feature => {
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
        expect(sanitized[attribute]).to be == params.fetch(:directory_feature).fetch(attribute)
      end # each
    end # it

    it 'excludes unrecognized attributes' do
      expect(sanitized).not_to have_key 'evil'
    end # it
  end # shared_examples

  ### Instance Methods ###

  describe '#build_resource_params' do
    include_context 'with request params'

    let(:directories) { [] }
    let(:sanitized)   { instance.build_resource_params params }

    before(:each) do
      instance.directories = directories
    end # before each

    expect_behavior 'sanitizes feature attributes'

    it 'assigns directory => nil' do
      expect(sanitized[:directory]).to be nil
    end # it

    context 'with many directories' do
      include_context 'with a valid path to a directory'

      it 'assigns directory => directories.last' do
        expect(sanitized[:directory]).to be == directories.last
      end # it
    end # context
  end # describe

  ### Routing Methods ###

  describe '#_resource_path' do
    context 'with a resource' do
      let(:attributes) { {} }
      let(:resource)   { build(:directory_feature, attributes) }

      before(:each) { allow(instance).to receive(:resource).and_return(resource) }

      it { expect(instance.send :_resource_path).to be == "/#{resource.slug}" }

      context 'with many directories' do
        include_context 'with a valid path to a directory'

        let(:attributes) { super().merge :directory => directories.last }

        it { expect(instance.send :_resource_path).to be == "/#{segments.join '/'}/#{resource.slug}" }
      end # context
    end # pending
  end # describe
end # describe
