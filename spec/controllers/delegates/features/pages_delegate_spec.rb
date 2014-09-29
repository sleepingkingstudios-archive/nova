# spec/controllers/delegates/features/pages_delegate_spec.rb

require 'rails_helper'

require 'delegates/features/pages_delegate'

RSpec.describe PagesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be Page
      end # it
    end # it
  end # describe
end # describe
