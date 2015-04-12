# spec/routing/admin/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for pages', :type => :routing do
  let(:pages_controller) { 'admin/features/pages' }

  describe 'GET /pages' do
    let(:path) { '/pages' }

    it 'routes to Admin::Features::PagesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'index'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/pages' do
    let(:path) { 'weapons/bows/arbalests/pages' }

    it 'routes to Admin::Features::PagesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'index',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'GET /pages/new' do
    let(:path) { 'pages/new' }

    it 'routes to Admin::Features::PagesController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'new'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/pages/new' do
    let(:path) { 'weapons/bows/arbalests/pages/new' }

    it 'routes to Admin::Features::PagesController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'new',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'POST /pages' do
    let(:path) { 'pages' }

    it 'routes to Admin::Features::PagesController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'create'
      }) # end hash
    end # it
  end # describe

  describe 'POST /path/to/directory/pages' do
    let(:path) { 'weapons/bows/arbalests/pages' }

    it 'routes to Admin::Features::PagesController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'create',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'POST /pages/preview' do
    let(:path) { 'pages/preview' }

    it 'routes to Admin::Features::PagesController#preview' do
      expect(:post => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'preview'
      }) # end hash
    end # it
  end # describe

  describe 'POST /path/to/directory/pages/preview' do
    let(:path) { 'weapons/bows/arbalests/pages/preview' }

    it 'routes to Admin::Features::PagesController#preview' do
      expect(:post => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'preview',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
