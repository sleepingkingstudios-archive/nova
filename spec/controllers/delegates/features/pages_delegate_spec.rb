# spec/controllers/delegates/features/pages_delegate_spec.rb

require 'rails_helper'

require 'delegates/features/pages_delegate'

RSpec.describe PagesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  shared_context 'with request params' do
    let(:params) do
      ActionController::Parameters.new(
        :page => {
          :title => 'Some Title',
          :slug  => 'Some Slug',
          :evil  => 'malicious'
        } # end hash
      ) # end hash
    end # let
  end # shared_context

  shared_examples 'sanitizes page attributes' do
    it 'whitelists page attributes' do
      %w(title slug).each do |attribute|
        expect(sanitized[attribute]).to be == params.fetch(:page).fetch(attribute)
      end # each
    end # it

    it 'excludes unrecognized attributes' do
      expect(sanitized).not_to have_key 'evil'
    end # it
  end # shared_examples

  shared_examples 'sets the request' do
    it 'sets the request' do
      perform_action

      expect(instance.request).to be == request
    end # it
  end # shared_examples

  let(:object)   { build(:page) }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be Page
      end # it
    end # it
  end # describe

  ### Instance Methods ###

  describe '#build_resource' do
    let(:params)  { ActionController::Parameters.new({}) }
    let(:request) { double('request', :params => ActionController::Parameters.new(params)) }

    def perform_action
      instance.build_resource instance.build_resource_params(params)
    end # method perform_action

    before(:each) { instance.request = request }

    it { expect(instance).to respond_to(:build_resource).with(1).argument }

    it 'creates the specified resource' do
      expect(perform_action).to be_a Page
    end # it

    it 'creates an embedded content' do
      object = perform_action

      expect(instance.resource).to be == object
      expect(instance.resource.content).to be_a TextContent
    end # it

    context 'with an implicit content type' do
      let(:params) { super().merge :page => { :content => { :_type => 'MarkdownContent' } } }

      it 'creates an embedded content' do
        object = perform_action

        expect(instance.resource.content).to be_a MarkdownContent
      end # it
    end # context

    context 'with an explicit content type' do
      let(:params) { super().merge :content_type => 'MarkdownContent' }

      it 'creates an embedded content' do
        object = perform_action

        expect(instance.resource.content).to be_a MarkdownContent
      end # it
    end # context
  end # describe

  describe '#build_resource_params' do
    include_context 'with request params'

    let(:directories) { [] }
    let(:sanitized)   { instance.build_resource_params params }

    before(:each) do
      instance.directories = directories
    end # before each

    expect_behavior 'sanitizes page attributes'

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

  describe '#content_params' do
    let(:content_params) { { 'text_content' => 'It was a dark and stormy night...' } }
    let(:params)         { { :page => { :content => content_params } } }

    it { expect(instance).to respond_to(:content_params).with(1).arguments }

    it { expect(instance.content_params params).to be == content_params }
  end # describe

  ### Actions ###

  describe '#new' do
    include_context 'with a controller'

    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    it 'assigns @resource' do
      instance.new request

      expect(assigns.fetch(:resource)).to be_a Page
      expect(assigns.fetch(:resource).content).to be_a Content
    end # it
  end # describe

  describe '#preview' do
    include_context 'with a controller'

    let(:object)     { Page }
    let(:attributes) { { :title => 'Feature Title', :slug => 'feature-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:page => attributes)) }

    it 'assigns resource with attributes and content' do
      instance.preview request

      resource = assigns.fetch(:resource)
      expect(resource).to be_a Page

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)

      expect(resource.content).to be_a Content
    end # it
  end # describe

  describe '#create' do
    include_context 'with a controller'

    let(:object)     { Page }
    let(:attributes) { { :title => 'Feature Title', :slug => 'feature-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:page => attributes)) }

    it 'assigns resource with attributes and content' do
      instance.create request

      resource = assigns.fetch(:resource)
      expect(resource).to be_a Page

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)

      expect(resource.content).to be_a Content
    end # it

    describe 'with invalid params' do
      let(:attributes) { {} }

      it 'renders the new template' do
        expect(controller).to receive(:render).with(instance.new_template_path)

        instance.create request
      end # it

      it 'does not create a page' do
        expect { instance.create request }.not_to change(Page, :count)
      end # it
    end # describe

    describe 'with valid params' do
      let(:page_attributes) { attributes_for(:page) }
      let(:attributes)      { page_attributes.merge :content => attributes_for(:text_content).merge(:_type => 'text_content') }
      let(:created_page)    { Page.where(page_attributes).first }

      it 'creates a page' do
        expect { instance.create request }.to change(Page, :count).by(1)
      end # it

      it 'redirects to the page' do
        expect(controller).to receive(:redirect_to).with("/#{attributes[:title].parameterize}")

        instance.create request

        expect(flash_messages[:success]).to be == "Page successfully created."
      end # it

      describe 'with a directory' do
        include_context 'with a valid path to a directory'

        before(:each) do
          instance.directories = directories
        end # before each

        it 'sets the page directory' do
          instance.create request

          expect(created_page.directory).to be == directories.last
        end # it

        it 'redirects to the page' do
          expect(controller).to receive(:redirect_to).with("/#{segments.join '/'}/#{attributes[:title].parameterize}")

          instance.create request
        end # it
      end # describe
    end # describe
  end # describe

  describe '#update' do
    include_context 'with a controller'

    let(:object)     { create(:page, :content => build(:text_content)) }
    let(:attributes) { { :title => 'Page Title', :slug => 'page-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:page => attributes)) }

    def perform_action
      instance.update request
    end # method perform_action

    it 'updates the resource attributes' do
      perform_action

      resource = assigns.fetch(:resource)
      expect(resource).to be == object

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)
    end # it

    expect_behavior 'sets the request'

    describe 'with invalid params' do
      let(:attributes) { { :title => nil } }

      it 'renders the edit template' do
        expect(controller).to receive(:render).with(instance.edit_template_path)

        perform_action

        expect(flash_messages.now[:warning]).to be_blank
      end # it

      it 'does not update the resource' do
        expect { perform_action }.not_to change { object.reload.title }
      end # it

      describe 'with content params' do
        let(:attributes) { super().merge :content => { :text_content => 'This content is deceased! It is an ex-content!' } }

        it 'updates the content attributes' do
          perform_action

          resource = assigns.fetch(:resource)
          content  = resource.content

          expect(content.text_content).to be == attributes.fetch(:content).fetch(:text_content)
        end # it
      end # describe
    end # describe

    describe 'with valid params' do
      let(:attributes) { { :title => 'Page Title', :slug => object.slug } }

      it 'redirects to the index path' do
        expect(controller).to receive(:redirect_to).with(instance.send :_resource_path)

        perform_action

        expect(flash_messages[:success]).to be == "Page successfully updated."
      end # it

      it 'updates the resource' do
        expect { perform_action }.to change { object.reload.title }.to(attributes[:title])
      end # it

      describe 'with content params' do
        let(:attributes) { super().merge :content => { :text_content => 'This content is deceased! It is an ex-content!' } }

        it 'updates the content attributes' do
          perform_action

          resource = assigns.fetch(:resource)
          content  = resource.content

          expect(content.text_content).to be == attributes.fetch(:content).fetch(:text_content)
        end # it
      end # describe
    end # describe
  end # describe
end # describe
