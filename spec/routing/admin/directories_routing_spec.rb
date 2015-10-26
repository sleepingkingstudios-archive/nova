# spec/routing/admin/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for directories', :type => :routing do
  let(:directories_controller) { 'admin/directories' }

  describe 'GET /dashboard' do
    let(:path) { '/dashboard' }

    it 'routes to Admin::DirectoriesController#dashboard' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'dashboard'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/dashboard' do
    let(:path) { 'weapons/bows/arbalests/dashboard' }

    it 'routes to Admin::DirectoriesController#dashboard' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'dashboard',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'GET /directories' do
    let(:path) { '/directories' }

    it 'routes to Admin::DirectoriesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'index'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/directories' do
    let(:path) { 'weapons/bows/arbalests/directories' }

    it 'routes to Admin::DirectoriesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'index',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'GET /directories/new' do
    let(:path) { 'directories/new' }

    it 'routes to Admin::DirectoriesController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'new'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/directories/new' do
    let(:path) { 'weapons/bows/arbalests/directories/new' }

    it 'routes to Admin::DirectoriesController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'new',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'POST /directories' do
    let(:path) { 'directories' }

    it 'routes to Admin::DirectoriesController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'create'
      }) # end hash
    end # it
  end # describe

  describe 'POST /path/to/directory/directories' do
    let(:path) { 'weapons/bows/arbalests/directories' }

    it 'routes to Admin::DirectoriesController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'create',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
