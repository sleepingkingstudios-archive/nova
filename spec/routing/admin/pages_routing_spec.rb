# spec/routing/admin/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for pages', :type => :routing do
  let(:pages_controller) { 'admin/features/pages' }

  describe 'GET /pages' do
    let(:path) { '/pages' }

    it 'routes to Admin::PagesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'index'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/directory/pages' do
    let(:path) { 'weapons/bows/arbalests/pages' }

    it 'routes to Admin::PagesController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller  => pages_controller,
        :action      => 'index',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
