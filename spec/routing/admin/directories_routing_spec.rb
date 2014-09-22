# spec/routing/admin/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for directories', :type => :routing do
  let(:directories_controller) { 'admin/directories' }
  let(:resources_controller)   { 'admin/resources' }

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

    it 'routes to DirectoriesController#dashboard' do
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

    it 'routes to DirectoriesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_controller,
        :action      => 'index',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
