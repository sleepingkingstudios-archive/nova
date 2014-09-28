# spec/controllers/delegates/directories_delegate_spec.rb

require 'rails_helper'

require 'delegates/directories_delegate'

RSpec.describe DirectoriesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  shared_context 'with request params', :params => true do
    let(:params) do
      ActionController::Parameters.new(
        :directory => {
          :title => 'Some Title',
          :slug  => 'Some Slug',
          :evil  => 'malicious'
        } # end hash
      ) # end hash
    end # let
  end # shared_context

  shared_examples 'sanitizes directory attributes' do
    it 'whitelists directory attributes' do
      %w(title slug).each do |attribute|
        expect(sanitized[attribute]).to be == params.fetch(:directory).fetch(attribute)
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
        expect(instance.resource_class).to be Directory
      end # it
    end # it
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

  describe '#directories' do
    it { expect(instance).to have_property(:directories) }
  end # describe

  describe '#resource_params', :params => true do
    let(:sanitized) { instance.resource_params params }

    expect_behavior 'sanitizes directory attributes'
  end # describe

  ### Actions ###

  describe '#new', :controller => true do
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

  describe '#create', :controller => true do
    let(:directories) { [] }
    let(:attributes)  { {} }
    let(:request)     { double('request', :params => ActionController::Parameters.new(:directory => attributes)) }

    before(:each) do
      instance.directories = directories
    end # before each

    describe 'with invalid params' do
      let(:attributes) { {} }

      it 'does not create a directory' do
        expect { instance.create request }.not_to change(Directory, :count)
      end # it
    end # describe

    describe 'with valid params' do
      let(:attributes) { attributes_for :directory }

      it 'creates a directory' do
        expect { instance.create request }.to change(Directory, :count).by(1)
      end # it

      it 'redirects to dashboard' do
        expect(controller).to receive(:redirect_to).with(/\A\/directory-\d+\/dashboard/)

        instance.create request
      end # it

      context 'with many directories', :path => :valid_directory do
        it 'sets the directory parent' do
          instance.create request

          expect(Directory.last.ancestors).to be == directories
        end # it

        it 'redirects to dashboard' do
          expect(controller).to receive(:redirect_to).with(/\A\/#{segments.join '/'}\/directory-\d+\/dashboard/)

          instance.create request
        end # it
      end # context
    end # describe
  end # describe

  ### Routing Methods ###

  describe '#dashboard_resource_path' do
    it { expect(instance.dashboard_resource_path).to be == "/dashboard" }

    context 'with one directory' do
      let(:directory) { build(:directory) }

      before(:each) { allow(instance).to receive(:resource).and_return(directory) }

      it { expect(instance.dashboard_resource_path).to be == "/#{directory.slug}/dashboard" }
    end # pending

    context 'with many directories', :path => :valid_directory do
      let(:directory)  { build(:directory, :parent => directories.last) }

      before(:each) do
        allow(instance).to receive(:resource).and_return(directory)

        instance.directories = directories
      end # before each
    
      it { expect(instance.dashboard_resource_path).to be == "/#{segments.join '/'}/#{directory.slug}/dashboard" }
    end # context
  end # describe

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
