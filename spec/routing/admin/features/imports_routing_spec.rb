# spec/routing/admin/directories/imports_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for feature imports', :type => :routing do
  let(:directories_imports_controller) { 'admin/features/imports' }

  describe 'GET /features/import/new' do
    let(:path) { 'features/import/new' }

    it 'routes to Admin::Features::ImportsController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_imports_controller,
        :action      => 'new'
      }) # end hash
    end # it
  end # describe

  describe 'GET /path/to/resource/features/import/new' do
    let(:path) { 'weapons/bows/arbalests/features/import/new' }

    it 'routes to Admin::Features::ImportsController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => directories_imports_controller,
        :action      => 'new',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
