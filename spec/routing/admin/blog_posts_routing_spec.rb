# spec/routing/admin/blog_posts_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for blogs', :type => :routing do
  let(:blog_posts_controller) { 'admin/features/blog_posts' }

  describe 'GET /blog/posts' do
    let(:path) { '/blog/posts' }

    it 'routes to Admin::Features::BlogPostsController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'index',
        :blog        => 'blog'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/blog/posts' do
    let(:path) { 'weapons/bows/arbalests/blog/posts' }

    it 'routes to Admin::Features::BlogPostsController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'index',
        :blog        => 'blog',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'GET /blog/posts/new' do
    let(:path) { '/blog/posts/new' }

    it 'routes to Admin::Features::BlogPostsController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'new',
        :blog        => 'blog'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/blog/posts/new' do
    let(:path) { 'weapons/bows/arbalests/blog/posts/new' }

    it 'routes to Admin::Features::BlogPostsController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'new',
        :blog        => 'blog',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'POST /blog/posts/preview' do
    let(:path) { '/blog/posts/preview' }

    it 'routes to Admin::Features::BlogPostsController#preview' do
      expect(:post => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'preview',
        :blog        => 'blog'
      }) # end hash
    end # it
  end # describe

  describe 'POST /path/to/directory/blog/posts/preview' do
    let(:path) { 'weapons/bows/arbalests/blog/posts/preview' }

    it 'routes to Admin::Features::BlogPostsController#preview' do
      expect(:post => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'preview',
        :blog        => 'blog',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe

  describe 'POST /blog/posts' do
    let(:path) { '/blog/posts' }

    it 'routes to Admin::Features::BlogPostsController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'create',
        :blog        => 'blog'
      }) # end hash
    end # it
  end # describe

  describe 'POST /path/to/directory/blog/posts' do
    let(:path) { 'weapons/bows/arbalests/blog/posts' }

    it 'routes to Admin::Features::BlogPostsController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => blog_posts_controller,
        :action      => 'create',
        :blog        => 'blog',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
