# spec/routing/admin/directories/imports_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for directory imports', :type => :routing do
  let(:directories_imports_controller) { 'admin/directories/imports' }

  describe 'GET /directories/import/new' do
    let(:path) { 'directories/import/new' }

    it 'routes to Admin::Directories::ImportsController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_imports_controller,
        :action      => 'new'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/resource/directories/import/new' do
    let(:path) { 'weapons/bows/arbalests/directories/import/new' }

    it 'routes to Admin::Directories::ImportsController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_imports_controller,
        :action      => 'new',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
