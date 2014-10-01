# spec/errors/authentication_error_spec.rb

require 'rails_helper'

require 'errors/authentication_error'

RSpec.describe Nova::AuthenticationError do
  let(:action)     { 'autodefenestrate' }
  let(:controller) { 'spec/examples' }
  let(:params)     { { :window => 'nearest' } }
  let(:request)    { { :action => action, :controller => controller, :params => params } }
  let(:instance)   { described_class.new request }

  describe '#initialize' do
    it { expect(described_class).to construct.with(1).arguments }
  end # describe

  describe '#action' do
    it { expect(instance).to have_reader(:action).with(action) }
  end # describe

  describe '#controller' do
    it { expect(instance).to have_reader(:controller).with(controller) }
  end # describe

  describe '#message' do
    it { expect(instance).to have_reader(:message).with("user not authorized to perform that action") }
  end # describe

  describe '#params' do
    it { expect(instance).to have_reader(:params).with(params) }
  end # describe

  describe '#request' do
    it { expect(instance).to have_reader(:request).with(request) }
  end # describe
end # describe
