# spec/controllers/delegates/features_delegate_spec.rb

# spec/controllers/delegates/directories_delegate_spec.rb

require 'rails_helper'

require 'delegates/features_delegate'

RSpec.describe FeaturesDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  let(:instance) { described_class.new }

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be Feature
      end # it
    end # it
  end # describe
end # describe
