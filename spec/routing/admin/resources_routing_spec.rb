# spec/routing/admin/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for directories', :type => :routing do
  let(:resources_controller) { 'admin/resources' }

  describe 'GET /path/to/directory/edit' do
    let(:path) { 'weapons/bows/arbalests/edit' }

    it 'routes to Admin::ResourcesController#edit' do
      expect(:get => "/#{path}").to route_to({
        :controller  => resources_controller,
        :action      => 'edit',
        :directories => 'weapons/bows/arbalests'
      }) # end hash
    end # it
  end # describe
end # describe
