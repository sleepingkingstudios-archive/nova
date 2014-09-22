# spec/controllers/directories_controller_spec.rb

require 'rails_helper'

RSpec.describe DirectoriesController, :type => :controller do
  include Rails.application.routes.url_helpers

  shared_context 'with an empty path', :path => :empty do
    let(:path)        { nil }
    let(:directories) { [] }
  end # shared_context

  shared_context 'with an invalid path', :path => :invalid do
    let(:segments) { %w(weapons swords japanese) }
    let(:path)     { segments.join('/') }
    let!(:directories) do
      [].tap do |ary|
        segments[0...-1].each do |segment|
          ary << create(:directory, :parent => ary[-1], :title => segment.capitalize)
        end # each
      end # tap
    end # let!
  end # shared_context

  shared_context 'with a valid path', :path => :valid do
    let(:segments) { %w(weapons swords japanese) }
    let(:path)     { segments.join('/') }
    let!(:directories) do
      [].tap do |ary|
        segments.each do |segment|
          ary << create(:directory, :parent => ary[-1], :title => segment.capitalize)
        end # each
      end # tap
    end # let!
  end # shared_context

  shared_examples 'assigns directories' do
    it 'assigns the directories to @directories' do
      perform_action

      expect(assigns :directories).to be == directories
      expect(assigns :current_directory).to be == directories.last
    end # it
  end # shared_examples

  shared_examples 'redirects to the last found directory' do
    it 'redirects to the last found directory' do
      perform_action

      expect(response.status).to be == 302
      expect(response).to redirect_to directory_path(assigns(:directories).last)

      expect(request.flash[:warning]).not_to be_blank
    end # it
  end # shared_examples

  shared_examples 'requires authentication' do |authenticate_root: true|
    before(:each) { sign_out :user }

    if authenticate_root
      describe 'with an empty path', :path => :empty do
        it 'redirects to root' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to root_path

          expect(request.flash[:warning]).not_to be_blank
        end # it
      end # describe
    end # if

    describe 'with an invalid path', :path => :invalid do
      it 'redirects to the last found directory' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to directory_path(assigns(:directories).last)

        expect(request.flash[:warning]).not_to be_blank
      end # it
    end # describe

    describe 'with a valid path', :path => :valid do
      it 'redirects to the last found directory' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to directory_path(assigns(:directories).last)

        expect(request.flash[:warning]).not_to be_blank
      end # it
    end # describe
  end # shared_examples

  let(:user) { create(:user) }

  describe '#show' do
    def perform_action
      get :show, :directories => path
    end # method perform_action

    describe 'with an empty path', :path => :empty do
      it 'renders the show template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:show)
      end # it

      expect_behavior 'assigns directories'
    end # describe

    describe 'with an invalid path', :path => :invalid do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid do
      it 'renders the show template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:show)
      end # it

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#index' do
    expect_behavior 'requires authentication'

    def perform_action
      get :index, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      it 'renders the index template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:index)
      end # it

      expect_behavior 'assigns directories'
    end # describe

    describe 'with an invalid path', :path => :invalid do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid do
      it 'renders the index template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:index)
      end # it

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#new' do
    expect_behavior 'requires authentication'

    def perform_action
      get :new, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      it 'renders the new template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:new)

        expect(assigns :directory).to be_a(Directory)
      end # it

      expect_behavior 'assigns directories'
    end # describe

    describe 'with an invalid path', :path => :invalid do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid do
      it 'renders the new template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:new)

        expect(assigns :directory).to be_a(Directory)
      end # it

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#create' do
    let(:attributes) { {} }

    expect_behavior 'requires authentication'

    def perform_action
      post :create, :directories => path, :directory => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an empty path', :path => :empty do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        it 'renders the new template' do
          perform_action

          expect(response.status).to be == 200
          expect(response).to render_template(:new)

          expect(assigns :directory).to be_a(Directory)
        end # it

        it 'does not create a directory' do
          expect { perform_action }.not_to change(Directory, :count)
        end # it

        expect_behavior 'assigns directories'
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:directory) }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(index_directory_path(assigns :directory))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new directory' do
          expect { perform_action }.to change(Directory, :count).by(1)
        end # it
      end # describe
    end # describe

    describe 'with an invalid path', :path => :invalid do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        it 'renders the new template' do
          perform_action

          expect(response.status).to be == 200
          expect(response).to render_template(:new)

          expect(assigns :directory).to be_a(Directory)
        end # it

        it 'does not create a directory' do
          expect { perform_action }.not_to change(Directory, :count)
        end # it

        expect_behavior 'assigns directories'
      end # describe

      describe 'with valid params' do
        let(:attributes) { attributes_for(:directory) }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(index_directory_path(assigns :directory))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'creates a new directory' do
          expect { perform_action }.to change(Directory, :count).by(1)

          expect(assigns(:directory).ancestors).to be == directories
        end # it
      end # describe
    end # describe
  end # describe

  describe '#edit' do
    expect_behavior 'requires authentication', :authenticate_root => false

    def perform_action
      get :edit, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an invalid path', :path => :invalid do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid do
      it 'renders the edit template' do
        perform_action

        expect(response.status).to be == 200
        expect(response).to render_template(:edit)
      end # it

      expect_behavior 'assigns directories'
    end # describe
  end # describe

  describe '#update' do
    let(:attributes) { {} }

    expect_behavior 'requires authentication', :authenticate_root => false

    def perform_action
      patch :update, :directories => path, :directory => attributes
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an invalid path', :path => :invalid do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid do
      describe 'with invalid params' do
        let(:attributes) { super().merge :title => nil }

        it 'renders the edit template' do
          perform_action

          expect(response.status).to be == 200
          expect(response).to render_template(:edit)
        end # it

        it 'does not update the directory' do
          expect { perform_action }.not_to change { Directory.last.reload.title }
        end # it

        expect_behavior 'assigns directories'
      end # describe

      describe 'with valid params' do
        let(:title)      { attributes_for(:directory).fetch(:title) }
        let(:attributes) { { :title => title } }

        it 'redirects to the directory' do
          perform_action

          expect(response.status).to be == 302
          expect(response).to redirect_to(index_directory_path(assigns :current_directory))

          expect(request.flash[:success]).not_to be_blank
        end # it

        it 'updates the directory' do
          expect { perform_action }.to change { Directory.last.reload.title }.to(title)
        end # it
      end # describe
    end # describe
  end # describe

  describe '#destroy' do
    expect_behavior 'requires authentication', :authenticate_root => false

    def perform_action
      delete :destroy, :directories => path
    end # method perform_action

    before(:each) { sign_in :user, user }

    describe 'with an invalid path', :path => :invalid do
      expect_behavior 'redirects to the last found directory'
    end # describe

    describe 'with a valid path', :path => :valid do
      it 'redirects to the directory' do
        perform_action

        expect(response.status).to be == 302
        expect(response).to redirect_to(index_directory_path(assigns(:directories)[-2]))

        expect(request.flash[:danger]).not_to be_blank
      end # it

      it 'destroys the directory' do
        expect { perform_action }.to change(Directory, :count).by(-1)
      end # it

      describe 'with a child directory' do
        before(:each) { create(:directory, :parent => directories.last) }

        it 'destroys the directory and child' do
          expect { perform_action }.to change(Directory, :count).by(-2)
        end # it
      end # describe

      describe 'with a feature' do
        before(:each) { create(:feature, :directory => directories.last) }

        it 'destroys the feature' do
          expect { perform_action }.to change(Feature, :count).by(-1)
        end # it
      end # describe
    end # describe
  end # describe
end # describe
