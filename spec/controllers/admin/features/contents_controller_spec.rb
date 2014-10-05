# spec/controllers/admin/features/contents_controller_spec.rb 

require 'rails_helper'

RSpec.describe Admin::Features::ContentsController, :type => :controller do
  shared_examples 'requires authentication' do
    before(:each) { sign_out :user }

    it 'redirects to root or gives a 403 forbidden response' do
      perform_action

      if request.xhr?
        expect(response.status).to be == 403
      else
        expect(response.status).to be == 302
        expect(response).to redirect_to root_path

        expect(request.flash[:warning]).not_to be_blank
      end # if-else
    end # it
  end # shared_examples

  let(:user) { create(:user) }

  describe '#edit' do
    expect_behavior 'requires authentication'

    def perform_action
      get :fields, :content_type => content_type
    end # method perform_action

    let(:content_type) { 'markdown' }

    before(:each) { sign_in :user, user }

    it 'redirects to root path' do
      perform_action

      expect(response.status).to be == 302
      expect(response).to redirect_to root_path

      expect(request.flash[:warning]).not_to be_blank
    end # it

    context 'with an xhr request' do
      render_views

      expect_behavior 'requires authentication'

      def perform_action
        xhr :get, :fields, :content_type => content_type
      end # method perform_action

      it 'renders the fields' do
        perform_action

        expect(response).not_to render_template(/layouts/)
        expect(response).to render_template('admin/features/contents/fields')
        expect(response).to render_template('admin/features/contents/markdown_contents/_fields')
      end # it
    end # context
  end # describe
end # describe
