# spec/controllers/delegates/directories/imports_delegate_spec.rb

require 'rails_helper'

require 'delegates/directories/imports_delegate'

RSpec.describe Directories::ImportsDelegate, :type => :decorator do
  include Spec::Contexts::SerializerContexts
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  include Spec::Examples::SerializerExamples

  let(:object)   { nil }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be Directory
      end # it
    end # it
  end # describe

  ### Actions ###

  describe '#new' do
    include_context 'with a controller'

    let(:directories) { [] }
    let(:request)     { double('request', :params => ActionController::Parameters.new({})) }

    before(:each) do
      instance.directories = directories
    end # before each

    it 'assigns a directory' do
      instance.new request

      expect(assigns[:resource]).to be_a Directory
    end # it
  end # describe

  ### Partial Methods ###

  describe '#new_template_path' do
    it { expect(instance).to have_reader(:new_template_path).with('admin/directories/imports/new') }
  end # describe
end # describe
