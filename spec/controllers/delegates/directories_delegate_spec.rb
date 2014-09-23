# spec/controllers/delegates/directories_delegate_spec.rb

require 'rails_helper'

require 'delegates/directories_delegate'

RSpec.describe DirectoriesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts

  shared_context 'with request params', :params => true do
    let(:params) do
      ActionController::Parameters.new(
        :title => 'Some Title',
        :slug  => 'Some Slug',
        :evil  => 'malicious'
      ) # end hash
    end # let
  end # shared_context

  shared_examples 'sanitizes directory attributes' do
    it 'whitelists directory attributes' do
      %w(title slug).each do |attribute|
        expect(sanitized[attribute]).to be == params[attribute]
      end # each
    end # it

    it 'excludes unrecognized attributes' do
      expect(sanitized).not_to have_key 'evil'
    end # it
  end # shared_examples

  let(:object)     { build(:directory) }
  let(:instance)   { described_class.new object }
  let(:controller) { double('controller', :render => nil) }

  describe '#directories' do
    it { expect(instance).to have_property(:directories) }
  end # describe

  ### Instance Methods ###

  describe '#build_resource_params', :params => true do
    let(:directories) { [] }
    let(:sanitized)   { instance.build_resource_params params }

    before(:each) do
      instance.directories = directories
    end # before each

    expect_behavior 'sanitizes directory attributes'

    it 'assigns parent => nil' do
      expect(sanitized[:parent]).to be nil
    end # it

    context 'with many directories', :path => :valid_directory do
      it 'assigns parent => directories.last' do
        expect(sanitized[:parent]).to be == directories.last
      end # it
    end # context
  end # describe

  describe '#resource_params', :params => true do
    let(:sanitized) { instance.resource_params params }

    expect_behavior 'sanitizes directory attributes'
  end # describe

  ### Routing Methods ###

  describe '#resources_path' do
    it { expect(instance.resources_path).to be == '/directories' }

    context 'with many directories', :path => :valid_directory do
      before(:each) do
        instance.directories = directories
      end # before each
    
      it { expect(instance.resources_path).to be == "/#{segments.join '/'}/directories" }
    end # context
  end # describe
end # describe
