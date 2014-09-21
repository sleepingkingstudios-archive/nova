# spec/routing/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'routing for directories', :type => :routing do
  let(:controller) { 'directories' }

  describe 'show routes' do
    let(:action) { 'show' }

    describe 'GET /' do
      let(:path) { '/' }

      it 'routes to DirectoriesController#show' do
        expect(:get => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action
        }) # end hash
      end # it
    end # describe

    describe 'GET /path/to/directory' do
      let(:path) { 'weapons/bows/arbalests' }

      it 'routes to DirectoriesController#show' do
        expect(:get => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action,
          :directories => path
        }) # end hash
      end # it
    end # describe

    describe 'GET /admin/path/to/directory' do
      let(:path) { 'admin/weapons/bows/arbalests' }

      it 'does not route' do
        expect(:get => "/#{path}").not_to be_routable
      end # it
    end # describe
  end # describe

  describe 'index routes' do
    let(:action) { 'index' }

    describe 'GET /index' do
      let(:path) { '/index' }

      it 'routes to DirectoriesController#index' do
        expect(:get => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action
        }) # end hash
      end # it
    end # describe

    describe 'GET /path/to/directory/index' do
      let(:path) { 'weapons/bows/arbalests/index' }

      it 'routes to DirectoriesController#index' do
        expect(:get => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action,
          :directories => 'weapons/bows/arbalests'
        }) # end hash
      end # it
    end # describe
  end # describe

  describe 'new routes' do
    let(:action) { 'new' }

    describe 'GET /directories/new' do
      let(:path) { 'directories/new' }

      it 'routes to DirectoriesController#new' do
        expect(:get => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action
        }) # end hash
      end # it
    end # describe

    describe 'GET /path/to/directory/directories/new' do
      let(:path) { 'weapons/bows/arbalests/directories/new' }

      it 'routes to DirectoriesController#new' do
        expect(:get => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action,
          :directories => 'weapons/bows/arbalests'
        }) # end hash
      end # it
    end # describe
  end # describe

  describe 'create routes' do
    let(:action) { 'create' }

    describe 'POST /directories' do
      let(:path) { 'directories' }

      it 'routes to DirectoriesController#create' do
        expect(:post => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action
        }) # end hash
      end # it
    end # describe

    describe 'POST /path/to/directory/directories' do
      let(:path) { 'weapons/bows/arbalests/directories' }

      it 'routes to DirectoriesController#create' do
        expect(:post => "/#{path}").to route_to({
          :controller  => controller,
          :action      => action,
          :directories => 'weapons/bows/arbalests'
        }) # end hash
      end # it
    end # describe
  end # describe
end # describe
