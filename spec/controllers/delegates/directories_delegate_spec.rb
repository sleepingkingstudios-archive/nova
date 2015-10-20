# spec/controllers/delegates/directories_delegate_spec.rb

require 'rails_helper'

require 'delegates/directories_delegate'

RSpec.describe DirectoriesDelegate, :type => :decorator do
  include Spec::Contexts::SerializerContexts
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  include Spec::Examples::SerializerExamples

  shared_context 'with request params' do
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

  ### Instance Methods ###

  describe '#build_resource_params' do
    include_context 'with request params'

    let(:directories) { [] }
    let(:sanitized)   { instance.build_resource_params params }

    before(:each) do
      instance.directories = directories
    end # before each

    expect_behavior 'sanitizes directory attributes'

    it 'assigns parent => nil' do
      expect(sanitized[:parent]).to be nil
    end # it

    context 'with many directories' do
      include_context 'with a valid path to a directory'

      it 'assigns parent => directories.last' do
        expect(sanitized[:parent]).to be == directories.last
      end # it
    end # context
  end # describe

  describe '#resource_params' do
    include_context 'with request params'

    let(:sanitized) { instance.resource_params params }

    expect_behavior 'sanitizes directory attributes'
  end # describe

  describe '#update_resource_params' do
    include_context 'with request params'

    let(:directories) { [] }
    let(:sanitized)   { instance.update_resource_params params }

    before(:each) do
      instance.directories = directories
    end # before each

    expect_behavior 'sanitizes directory attributes'
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

  describe '#create' do
    include_context 'with a controller'

    let(:directories) { [] }
    let(:attributes)  { {} }
    let(:request)     { double('request', :params => ActionController::Parameters.new(:directory => attributes)) }

    before(:each) do
      instance.directories = directories
    end # before each

    describe 'with invalid params' do
      let(:attributes) { {} }

      it 'renders the new template' do
        expect(controller).to receive(:render).with(instance.new_template_path)

        instance.create request
      end # it

      it 'does not create a directory' do
        expect { instance.create request }.not_to change(Directory, :count)
      end # it
    end # describe

    describe 'with valid params' do
      let(:attributes)        { attributes_for :directory }
      let(:created_directory) { Directory.where(attributes).first }

      it 'creates a directory' do
        expect { instance.create request }.to change(Directory, :count).by(1)
      end # it

      it 'redirects to dashboard' do
        expect(controller).to receive(:redirect_to).with(/\A\/directory-\d+\/dashboard/)

        instance.create request
      end # it

      context 'with many directories' do
        include_context 'with a valid path to a directory'

        it 'sets the directory parent' do
          instance.create request

          expect(created_directory.ancestors).to be == directories
        end # it

        it 'redirects to dashboard' do
          expect(controller).to receive(:redirect_to).with(/\A\/#{segments.join '/'}\/directory-\d+\/dashboard/)

          instance.create request
        end # it
      end # context
    end # describe
  end # describe

  describe '#show' do
    include_context 'with a controller'

    let(:object)  { create(:directory) }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    it 'renders the show template' do
      expect(controller).to receive(:render).with(instance.show_template_path)

      instance.show request

      expect(assigns[:resource]).to be == object
    end # it

    describe 'with an unpublished index page' do
      let!(:index_page) { create(:page, :directory => object, :slug => 'index', :content => build(:content)) }

      it 'renders the directory show template' do
        expect(controller).to receive(:render).with(instance.show_template_path)

        instance.show request

        expect(assigns[:resource]).to be == object
      end # it
    end # describe

    describe 'with an index page' do
      let!(:index_page) { create(:page, :directory => object, :slug => 'index', :published_at => 1.day.ago, :content => build(:content)) }

      it 'renders the page show template' do
        expect(controller).to receive(:render).with(instance.page_template_path)

        instance.show request

        expect(assigns[:resource]).to be == index_page
      end # it
    end # describe
  end # describe

  describe '#dashboard' do
    include_context 'with a controller'

    let(:object)  { create(:directory) }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    it 'renders the dashboard template' do
      expect(controller).to receive(:render).with(instance.dashboard_template_path)

      instance.dashboard request
    end # it
  end # describe

  describe '#export' do
    include_context 'with a controller'

    let(:blacklisted_attributes) { %w(_id _type directories features directory_id parent_id) }

    shared_examples 'should export the directory as JSON' do |proc|
      it 'should export the directory as JSON' do
        serialized = nil

        expect(controller).to receive(:render) do |options|
          expect(options).to have_key :json

          serialized = JSON.parse options[:json]
          expect(serialized).to be_a Hash
        end # expect

        perform_action

        expect_to_serialize_attributes serialized, directory

        SleepingKingStudios::Tools::ObjectTools.apply self, proc, serialized if proc.respond_to?(:call)
      end # it
    end # shared_examples

    shared_examples 'should export the directory and all children and features' do
      wrap_examples 'should export the directory as JSON', ->(serialized) {
        expect(serialized['directories']).to be_blank

        expect(serialized['features']).to be_blank
      } # end examples

      context 'with many features' do
        let!(:pages) { Array.new(3) { create(:page, :content => build(:content), :directory => directory) } }

        wrap_examples 'should export the directory as JSON', ->(serialized) {
          expect(serialized['directories']).to be_blank

          expect_to_serialize_directory_features serialized, directory
        } # end examples
      end # context

      context 'with many child directories' do
        let!(:children)      { Array.new(3) { create(:directory, :parent => (directory.is_a?(Directory) ? directory : nil)) } }
        let!(:grandchildren) { Array.new(3) { create(:directory, :parent => children.first) } }

        wrap_examples 'should export the directory as JSON', ->(serialized) {
          expect_to_serialize_directory_children serialized, directory, :recursive => true, :relations => :all

          expect(serialized['features']).to be_blank
        } # end examples

        context 'with many features' do
          before(:each) do
            [directory, *children, *grandchildren].each do |directory_or_descendant|
              3.times { create(:page, :content => build(:content), :directory => (directory_or_descendant.is_a?(Directory) ? directory_or_descendant : nil)) }
            end # each
          end # before each

          wrap_examples 'should export the directory as JSON', ->(serialized) {
            expect_to_serialize_directory_children serialized, directory, :recursive => true, :relations => :all

            expect_to_serialize_directory_features serialized, directory
          } # end examples
        end # context
      end # context
    end # shared_examples

    let(:exporter) { Object.new.extend(ExportersHelper) }
    let(:request)  { double('request', :params => ActionController::Parameters.new({})) }

    def perform_action
      instance.export request
    end # method perform_action

    it { expect(instance).to respond_to(:export).with(1).argument }

    describe 'with the root directory' do
      let(:directory) { RootDirectory.instance }

      include_examples 'should export the directory and all children and features'
    end # describe

    describe 'with a directory' do
      let(:directory) { create(:directory) }
      let(:object)    { directory }

      include_examples 'should export the directory and all children and features'
    end # describe
  end # describe

  describe '#import_directory' do
    include_context 'with a controller'

    let(:object)  { create(:directory) }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    def perform_action
      instance.import_directory request
    end # method perform_action

    it { expect(instance).to respond_to(:import_directory).with(1).argument }

    it 'renders the import template' do
      expect(controller).to receive(:render).with(instance.import_directory_template_path)

      perform_action
    end # it
  end # describe

  describe '#import_feature' do
    include_context 'with a controller'

    let(:object)  { create(:directory) }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    def perform_action
      instance.import_feature request
    end # method perform_action

    it { expect(instance).to respond_to(:import_feature).with(1).argument }

    it 'renders the import template' do
      expect(controller).to receive(:render).with(instance.import_feature_template_path)

      perform_action
    end # it
  end # describe

  ### Partial Methods ###

  describe '#dashboard_template_path' do
    it { expect(instance).to have_reader(:dashboard_template_path).with('admin/directories/dashboard') }
  end # describe

  describe '#import_directory_template_path' do
    it { expect(instance).to have_reader(:import_directory_template_path).with('admin/directories/import') }
  end # describe

  describe '#import_feature_template_path' do
    it { expect(instance).to have_reader(:import_feature_template_path).with('admin/features/import') }
  end # describe

  describe '#page_template_path' do
    it { expect(instance).to have_reader(:page_template_path).with('features/pages/show') }
  end # describe

  ### Routing Methods ###

  describe '#_dashboard_resource_path' do
    it { expect(instance.send :_dashboard_resource_path).to be == '/dashboard' }

    context 'with one directory' do
      let(:directory) { build(:directory) }

      before(:each) { allow(instance).to receive(:resource).and_return(directory) }

      it { expect(instance.send :_dashboard_resource_path).to be == "/#{directory.slug}/dashboard" }
    end # context

    context 'with many directories' do
      include_context 'with a valid path to a directory'

      let(:directory)  { build(:directory, :parent => directories.last) }

      before(:each) do
        allow(instance).to receive(:resource).and_return(directory)

        instance.directories = directories
      end # before each

      it { expect(instance.send :_dashboard_resource_path).to be == "/#{segments.join '/'}/#{directory.slug}/dashboard" }
    end # context
  end # describe

  describe '#_resources_path' do
    it { expect(instance.send :_resources_path).to be == '/directories' }

    context 'with many directories' do
      include_context 'with a valid path to a directory'

      before(:each) do
        instance.directories = directories
      end # before each

      it { expect(instance.send :_resources_path).to be == "/#{segments.join '/'}/directories" }
    end # context
  end # describe
end # describe
