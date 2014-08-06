# spec/models/user.rb

require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:attributes) { FactoryGirl.attributes_for :user }
  let(:instance)   { described_class.new attributes }

  describe 'validation' do
    it { expect(instance).to be_valid }
  end # describe  
end # describe
