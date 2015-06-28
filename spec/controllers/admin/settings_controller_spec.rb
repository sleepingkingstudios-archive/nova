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

  shared_examples 'requires authentication' do |xhr_request: false|
    before(:each) { sign_out :user }

    it 'redirects to the root path' do
      perform_action

      if xhr_request
        expect(response.status).to be == 403
        expect(response.body.strip).to be_blank
      else
        expect(response.status).to be == 302
        expect(response).to redirect_to root_path

        expect(request.flash[:warning]).not_to be_blank
      end # if-else
    end # it
  end # shared_examples

  let(:user) { create(:user) }

  describe 'GET #index' do
    def perform_action
      get :index
    end # method perform_action

    before(:each) { sign_in :user, user }

    expect_behavior 'requires authentication'

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

  describe 'PATCH #update' do
    let(:setting)    { create(:setting) }
    let(:attributes) { {} }
    let(:params)     { { :id => setting.try(:id), :setting => attributes } }
    let(:json)       { begin JSON.parse(response.body); rescue JSON::ParserError; {}; end }

    def perform_action
      xhr :patch, :update, params
    end # method perform_action

    before(:each) { sign_in :user, user }

    expect_behavior 'requires authentication', :xhr_request => true

    describe 'with a string setting' do
      let(:setting)      { create(:string_setting) }
      let(:setting_keys) { %w(key value options) }

      describe 'with invalid params' do
        let(:attributes) { super().merge :value => nil, :options => { 'validate_presence' => true } }

        it 'responds with 422 Unprocessable Entity and a JSON list of errors' do
          perform_action

          expect(response.status).to be == 422

          expect(json.fetch 'error').to be == 'Unable to update setting.'

          setting_data = json.fetch('setting')
          expect(setting_data.keys).to contain_exactly 'errors', '_type', *setting_keys

          expect(setting_data.fetch 'errors').to be_a Array
          expect(setting_data.fetch 'errors').to contain_exactly "Value can't be blank"

          attributes.each do |attribute, value|
            expect(setting_data.fetch attribute.to_s).to be == value
          end # each
        end # it
      end # describe

      describe 'with valid params' do
        let(:attributes) { super().merge :value => 'The long day wanes, the slow moon climbs, the deep moans round with many voices.' }

        it 'responds with 200 OK and the setting serialized as JSON' do
          perform_action

          expect(response.status).to be == 200

          setting_data = json.fetch('setting')
          expect(setting_data.keys).to contain_exactly '_type', *setting_keys

          attributes.each do |attribute, value|
            expect(setting_data.fetch attribute.to_s).to be == value
          end # each
        end # it
      end # describe
    end # describe
  end # describe
end # describe
