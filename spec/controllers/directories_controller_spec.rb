# spec/controllers/directories_controller_spec.rb

require 'rails_helper'

RSpec.describe DirectoriesController, :type => :controller do
  describe 'GET #show' do
    def perform_action
      get :show, :directories => path
    end # method perform_action

    describe 'with an empty path' do
      def perform_action
        get :show
      end # method perform_action

      it 'renders the show template' do
        perform_action
        expect(response.status).to be == 200
        expect(response).to render_template(:show)
      end # it

      it 'assigns an empty array to @directories' do
        perform_action
        expect(assigns :directories).to be == []
      end # it
    end # describe

    describe 'with a valid path' do
      let(:segments) { %w(weapons swords japanese) }
      let(:path)     { segments.join('/') }
      let!(:directories) do
        [].tap do |ary|
          segments.each do |segment|
            ary << FactoryGirl.create(:directory, :parent => ary[-1], :title => segment.capitalize)
          end # each
        end # tap
      end # let!

      it 'renders the show template' do
        perform_action
        expect(response.status).to be == 200
        expect(response).to render_template(:show)
      end # it

      it 'assigns the directories to @directories' do
        perform_action
        expect(assigns :directories).to be == directories
      end # it
    end # describe

    describe 'with an invalid path' do
      let(:segments) { %w(weapons swords japanese) }
      let(:path)     { segments.join('/') }
      let!(:directories) do
        [].tap do |ary|
          segments[0...-1].each do |segment|
            ary << FactoryGirl.create(:directory, :parent => ary[-1], :title => segment.capitalize)
          end # each
        end # tap
      end # let!

      it 'renders the show template' do
        perform_action
        expect(response.status).to be == 200
        expect(response).to render_template(:show)
      end # it

      it 'assigns the found directories to @directories' do
        perform_action
        expect(assigns :directories).to be == directories
      end # it
    end # describe
  end # describe
end # describe
