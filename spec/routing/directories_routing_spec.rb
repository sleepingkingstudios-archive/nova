# spec/routing/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'routing for directories', :type => :routing do
  describe 'GET /path/to/directory' do
    let(:path) { 'weapons/bows/arbalests' }

    it 'routes to DirectoriesController#show' do
      expect(:get => "/#{path}").to route_to({
        :controller  => 'directories',
        :action      => 'show',
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

  describe 'GET /index' do
    let(:path) { '/index' }

    it 'routes to DirectoriesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => 'directories',
        :action      => 'index'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/index' do
    let(:path) { 'weapons/bows/arbalests/index' }

    it 'routes to DirectoriesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => 'directories',
        :action      => 'index',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
