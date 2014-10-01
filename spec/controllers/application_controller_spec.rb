# spec/controllers/application_controller_spec.rb

require 'rails_helper'

require 'errors/authentication_error'

RSpec.describe ApplicationController, :type => :controller do
  describe '#authenticate_user!' do
    context 'as an anonymous user' do
      before(:each) { sign_out :user }

      it 'does not raise an error' do
        expect { controller.send :authenticate_user! }.not_to raise_error
      end # it
    end # context

    context 'as an authenticated user' do
      let(:user) { create(:user) }

      before(:each) { sign_in :user, user }

      it 'does not raise an error' do
        expect { controller.send :authenticate_user! }.not_to raise_error
      end # it
    end # context
  end # describe
end # describe
