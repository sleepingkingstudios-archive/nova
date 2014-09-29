# spec/controllers/delegates/resources_delegate_spec.rb

require 'rails_helper'

require 'delegates/resources_delegate'

RSpec.describe ResourcesDelegate, :type => :decorator do
  include Spec::Contexts::Delegates::DelegateContexts

  let(:object)   { Feature.new }
  let(:instance) { described_class.new object }

  shared_context 'with an array of objects', :object => :array do
    let(:object) { Array.new(3).map { Object.new } }
  end # shared_context

  shared_context 'with a class object', :object => :class do
    let(:object) { String }
  end # shared_context

  ### Class Methods ###

  describe '::new' do
    it { expect(described_class).to construct.with(1).arguments }
  end # describe

  ### Instance Methods ###

  describe '#assign', :controller => true do
    it { expect(instance).to respond_to(:assign).with(2).arguments }

    it 'changes the assigned variables in the controller' do
      expect { instance.assign :user, 'Alan Bradley' }.to change { assigns[:user] }.to('Alan Bradley')
    end # it
  end # describe

  describe '#build_resource' do
    it { expect(instance).to respond_to(:build_resource).with(1).argument }

    it 'creates the specified resource' do
      expect(instance.build_resource nil).to be_a Feature
    end # expect

    it 'caches the document in @resource' do
      object = instance.build_resource nil

      expect(instance.resource).to be == object
      expect(instance.resources).to be nil
    end # it
  end # describe

  describe '#build_resource_params' do
    let(:params) { ActionController::Parameters.new(:feature => { :evil => 'malicious' }) }

    it { expect(instance).to respond_to(:build_resource_params).with(1).argument }

    it { expect(instance.build_resource_params params).to be == {} }
  end # describe

  describe '#controller' do
    it { expect(instance).to have_property(:controller) }

    it { expect(instance.controller).to be nil }
  end # describe

  describe '#directories' do
    it { expect(instance).to have_property(:directories) }
  end # describe

  describe '#load_resources' do
    let(:documents) { Array.new(3).map { double('document') } }

    before(:each) do
      allow(Feature).to receive(:all).and_return(documents)
    end # before each

    it { expect(instance).to respond_to(:load_resources).with(0).arguments }

    it 'returns the specified resources' do
      expect(instance.load_resources).to be == documents
    end # it

    it 'caches the documents in @resources' do
      instance.load_resources

      expect(instance.resource).to be nil
      expect(instance.resources).to be == documents
    end # it
  end # describe

  describe '#resource' do
    it { expect(instance).to have_reader(:resource).with(object) }

    context 'with an array of objects', :object => :array do
      it { expect(instance.resource).to be nil }
    end # context

    context 'with a class object', :object => :class do
      it { expect(instance.resource).to be nil }
    end # context
  end # describe

  describe '#resources' do
    it { expect(instance).to have_reader(:resources).with(nil) }

    context 'with an array of objects', :object => :array do
      it { expect(instance.resources).to be == object }
    end # context

    context 'with a class object', :object => :class do
      it { expect(instance.resources).to be nil }
    end # context
  end # describe

  describe '#resource_class' do
    it { expect(instance).to have_reader(:resource_class).with(object.class) }

    context 'with an array of objects' do
      let(:object) { Array.new(3).map { Object.new } }

      it { expect(instance.resource_class).to be == object.first.class }
    end # context

    context 'with a class object' do
      let(:object) { String }

      it { expect(instance.resource_class).to be == object }
    end # context
  end # describe

  describe '#resource_name' do
    it { expect(instance).to have_reader(:resource_name).with(object.class.name.tableize) }

    context 'with an array of objects' do
      let(:object) { Array.new(3).map { Object.new } }

      it { expect(instance.resource_name).to be == object.first.class.name.tableize }
    end # context

    context 'with a class object' do
      let(:object) { String }

      it { expect(instance.resource_name).to be == object.name.tableize }
    end # context
  end # describe

  describe '#resource_params' do
    let(:params) { ActionController::Parameters.new(:feature => { :evil => 'malicious' }) }

    it { expect(instance).to respond_to(:resource_params).with(1).argument }

    it { expect(instance.resource_params params).to be == {} }
  end # describe

  describe '#set_flash_message', :controller => true do
    let(:key) { :warning }
    let(:message) do
      'Unable to log you out because you are not logged in. Please log in so you can log out.'
    end # message

    it { expect(instance).to respond_to(:set_flash_message).with(2..3).arguments }

    it 'sets the flash message for the next request' do
      expect { instance.set_flash_message key, message }.to change { flash_messages[key] }.to(message)
    end # it

    context 'with now => true' do
      it 'sets the flash message for the next request' do
        expect { instance.set_flash_message key, message, :now => true }.to change { flash_messages.now[key] }.to(message)
      end # it
    end # context
  end # describe

  describe '#update_resource_params' do
    let(:params) { ActionController::Parameters.new(:feature => { :evil => 'malicious' }) }

    it { expect(instance).to respond_to(:update_resource_params).with(1).argument }

    it { expect(instance.update_resource_params params).to be == {} }
  end # describe

  ### Actions ###

  describe '#index', :controller => true do
    let(:documents)  { Array.new(3).map { double('document') } }
    let(:object)     { Feature }
    let(:request)    { double('request') }

    before(:each) do
      allow(object).to receive(:all).and_return(documents)
    end # before each

    it { expect(instance).to respond_to(:index).with(1).arguments }

    it 'assigns resources' do
      instance.index request

      expect(assigns.fetch(:resources)).to be == documents
    end # it

    it 'renders the index template' do
      expect(controller).to receive(:render).with(instance.index_template_path)

      instance.index request
    end # it
  end # describe

  describe '#new', :controller => true do
    let(:object)  { Feature }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    it { expect(instance).to respond_to(:new).with(1).arguments }

    it 'assigns resource' do
      instance.new request

      expect(assigns.fetch(:resource)).to be_a Feature
    end # it

    it 'renders the new template' do
      expect(controller).to receive(:render).with(instance.new_template_path)

      instance.new request
    end # it
  end # describe

  describe '#create', :controller => true do
    let(:object)     { Feature }
    let(:attributes) { { :title => 'Feature Title', :slug => 'feature-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:feature => attributes)) }

    before(:each) do
      allow(instance).to receive(:build_resource_params) do |params|
        params.fetch(:feature).permit(:title, :slug)
      end # allow
    end # before each

    it { expect(instance).to respond_to(:create).with(1).arguments }

    it 'assigns resource with attributes' do
      instance.create request

      resource = assigns.fetch(:resource)
      expect(resource).to be_a Feature

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)
    end # it

    describe 'with invalid params' do
      let(:attributes) { {} }

      it 'renders the new template' do
        expect(controller).to receive(:render).with(instance.new_template_path)

        instance.create request

        expect(flash_messages.now[:warning]).to be == "Unable to create feature."
      end # it

      it 'does not create a resource' do
        expect { instance.create request }.not_to change(Feature, :count)
      end # it
    end # describe

    describe 'with valid params' do
      let(:attributes) { attributes_for :feature }

      it 'redirects to the index path' do
        expect(controller).to receive(:redirect_to).with(instance.index_resources_path)

        instance.create request

        expect(flash_messages[:success]).to be == "Feature successfully created."
      end # it

      it 'creates a resource' do
        expect { instance.create request }.to change(Feature, :count).by(1)
      end # it
    end # describe
  end # describe

  describe '#edit', :controller => true do
    let(:object)  { build(:feature) }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    it { expect(instance).to respond_to(:edit).with(1).argument }

    it 'renders the new template' do
      expect(controller).to receive(:render).with(instance.edit_template_path)

      instance.edit request
    end # it
  end # describe

  describe '#update', :controller => true do
    let(:object)     { create(:feature) }
    let(:attributes) { { :title => 'Feature Title', :slug => 'feature-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:feature => attributes)) }

    it { expect(instance).to respond_to(:update).with(1).argument }

    before(:each) do
      allow(instance).to receive(:update_resource_params) do |params|
        params.fetch(:feature).permit(:title, :slug)
      end # allow
    end # before each

    it 'updates the resource attributes' do
      instance.update request

      resource = assigns.fetch(:resource)
      expect(resource).to be == object

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)
    end # it

    describe 'with invalid params' do
      let(:attributes) { { :title => nil } }

      it 'renders the edit template' do
        expect(controller).to receive(:render).with(instance.edit_template_path)

        instance.update request

        expect(flash_messages.now[:warning]).to be == "Unable to update feature."
      end # it

      it 'does not update the resource' do
        expect { instance.create request }.not_to change { object.reload.title }
      end # it
    end # describe

    describe 'with valid params' do
      let(:attributes) { attributes_for :feature }

      it 'redirects to the index path' do
        expect(controller).to receive(:redirect_to).with(instance.index_resources_path)

        instance.update request

        expect(flash_messages[:success]).to be == "Feature successfully updated."
      end # it

      it 'updates the resource' do
        expect { instance.update request }.to change { object.reload.title }.to(attributes[:title])
      end # it
    end # describe
  end # describe

  describe '#destroy', :controller => true do
    let(:object)  { create(:feature) }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    it { expect(instance).to respond_to(:destroy).with(1).argument }

    it 'redirects to the index path' do
      expect(controller).to receive(:redirect_to).with(instance.index_resources_path)

      instance.destroy request

      expect(flash_messages[:danger]).to be == "Feature successfully destroyed."
    end # it

    it 'destroys the resource' do
      expect { instance.destroy request }.to change(Feature, :count).by(-1)
    end # it
  end # describe

  ### Partial Methods ###

  describe '#index_template_path' do
    it { expect(instance).to have_reader(:index_template_path).with('admin/features/index') }
  end # describe

  describe '#new_template_path' do
    it { expect(instance).to have_reader(:new_template_path).with('admin/features/new') }
  end # describe

  describe '#edit_template_path' do
    it { expect(instance).to have_reader(:edit_template_path).with('admin/features/edit') }
  end # describe

  ### Routing Methods ###

  describe '#create_resource_path' do
    it { expect(instance).to have_reader(:create_resource_path).with('features') }
  end # describe

  describe '#index_resources_path' do
    it { expect(instance).to have_reader(:index_resources_path).with('features') }
  end # describe

  describe '#resource_path' do
    it { expect(instance).to have_reader(:resource_path).with("features/#{object.id}") }
  end # describe

  describe '#resources_path' do
    it { expect(instance).to have_reader(:resources_path).with('features') }
  end # describe
end # describe
