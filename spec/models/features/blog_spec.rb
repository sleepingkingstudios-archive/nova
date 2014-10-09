# spec/models/features/blog_spec.rb

require 'rails_helper'

RSpec.describe Blog, :type => :model do
  let(:attributes) { attributes_for(:blog) }
  let(:instance)   { described_class.new attributes }

  describe '#validation' do
    it { expect(instance).to be_valid }
  end # describe
end # describe
