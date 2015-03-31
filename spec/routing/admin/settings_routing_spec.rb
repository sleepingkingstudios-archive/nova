# spec/routing/admin/settings_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for settings', :type => :routing do
  let(:settings_controller) { 'admin/settings' }

  describe 'GET /admin/settings' do
    let(:path) { 'admin/settings' }

    it 'routes to Admin::SettingsController#index' do
      expect(:get => "/#{path}").to route_to({
        :controller => settings_controller,
        :action     => 'index'
      }) # end hash
    end # it
  end # describe

  describe 'PUT /admin/settings' do
    let(:setting) { create(:setting) }
    let(:path)    { "admin/settings/#{setting.id}" }

    it 'routes to Admin::SettingsController#update' do
      expect(:put => "/#{path}").to route_to({
        :controller => settings_controller,
        :action     => 'update',
        :id         => setting.id.to_s
      }) # end hash
    end # it
  end # describe

  describe 'PATCH /admin/settings' do
    let(:setting) { create(:setting) }
    let(:path)    { "admin/settings/#{setting.id}" }

    it 'routes to Admin::SettingsController#update' do
      expect(:patch => "/#{path}").to route_to({
        :controller => settings_controller,
        :action     => 'update',
        :id         => setting.id.to_s
      }) # end hash
    end # it
  end # describe
end # describe
