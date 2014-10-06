# spec/routing/admin/directories_routing_spec.rb

require 'rails_helper'

RSpec.describe 'admin routing for contents', :type => :routing do
  let(:contents_controller) { 'admin/features/contents' }

  describe 'GET /admin/contents/:content_type/fields' do
    let(:content_type) { 'text_content' }
    let(:path)         { "/admin/contents/#{content_type}/fields" }

    it 'routes to Admin::Features::ContentsController#fields' do
      expect(:get => "/#{path}").to route_to({
        :controller   => contents_controller,
        :action       => 'fields',
        :content_type => content_type
      }) # end hash
    end # it
  end # describe
end # describe
