# spec/controllers/admin/settings_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::SettingsController, :type => :controller do
  include Spec::Examples::Controllers::RenderingExamples

  shared_context 'with many settings' do
    let(:settings_hash) do
      { 'ace.title'      => 'Baron',
        'ace.first_name' => 'Manfred',
        'ace.last_name'  => 'von Richthofen'
      } # end hash
    end # let
    let!(:settings) do
      settings_hash.map do |key, value|
        create(:string_setting, :key => key, :value => value)
      end # each
    end # let!
  end # context

  describe 'GET #index' do
    def perform_action
      get :index
    end # method perform_action

    expect_behavior 'renders template', :index

    it 'assigns @settings' do
      perform_action

      expect(assigns :settings).to be == []
    end # it

    context 'with many settings' do
      include_context 'with many settings'

      it 'assigns @settings' do
        perform_action

        expect(assigns :settings).to be == settings
      end # it
    end # context
  end # describe
end # describe
