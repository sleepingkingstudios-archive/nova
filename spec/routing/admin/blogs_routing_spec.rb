# spec/routing/admin/blogs_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for blogs', :type => :routing do
  let(:blogs_controller) { 'admin/features/blogs' }

  describe 'GET /blogs' do
    let(:path) { '/blogs' }

    it 'routes to Admin::Features::BlogsController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blogs_controller,
        :action      => 'index'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/blogs' do
    let(:path) { 'weapons/bows/arbalests/blogs' }

    it 'routes to Admin::Features::BlogsController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blogs_controller,
        :action      => 'index',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'GET /blogs/new' do
    let(:path) { 'blogs/new' }

    it 'routes to Admin::Features::PagesController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blogs_controller,
        :action      => 'new'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/blogs/new' do
    let(:path) { 'weapons/bows/arbalests/blogs/new' }

    it 'routes to Admin::Features::PagesController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blogs_controller,
        :action      => 'new',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'POST /blogs' do
    let(:path) { 'blogs' }

    it 'routes to Admin::Features::PagesController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => blogs_controller,
        :action      => 'create'
      }) # end hash
    end # it
  end # describe

  describe 'POST /path/to/directory/blogs' do
    let(:path) { 'weapons/bows/arbalests/blogs' }

    it 'routes to Admin::Features::PagesController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => blogs_controller,
        :action      => 'create',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
