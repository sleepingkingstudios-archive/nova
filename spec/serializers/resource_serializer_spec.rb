# spec/serializers/resource_serializer_spec.rb

require 'rails_helper'

RSpec.describe ResourceSerializer, :type => :decorator do
  let(:resource) { double('resource', :errors => nil) }
  let(:instance) { described_class.new resource }

  describe '#to_json' do
    it { expect(instance).to respond_to(:to_json).with(0).arguments }

    it { expect(instance.to_json).to be == {} }

    describe 'with error messages' do
      let(:messages) { ['Unable to log out because you are not logged in. Please log in so you can log out.'] }
      let(:errors)   { double('errors', :full_messages => messages) }

      before(:each) { allow(resource).to receive(:errors).and_return(errors) }

      it { expect(instance.to_json).to be == { 'errors' => messages } }
    end # describe
  end # describe
end # describe
