# spec/controllers/scaffold_controller_spec.rb

require 'rails_helper'

RSpec.describe ScaffoldController, :type => :controller do
  describe 'GET #root' do
    def perform_action
      get :root
    end # method perform_action

    it 'renders the root template' do
      perform_action
      expect(response.status).to be == 200
      expect(response).to render_template(:root)
    end # it
  end # describe
end # describe
