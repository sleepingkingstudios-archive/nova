# spec/models/features/blog_spec.rb

require 'rails_helper'

RSpec.describe Blog, :type => :model do
  let(:attributes) { attributes_for(:blog) }
  let(:instance)   { described_class.new attributes }

  ### Relations ###

  describe '#posts' do
    it { expect(instance).to have_reader(:posts).with([]) }

    describe 'with many posts' do
      let!(:posts) { Array.new(3).map { create(:blog_post, :blog => instance, :content => build(:content)) } }

      it { expect(instance.posts).to contain_exactly(*posts) }
    end # describe
  end # describe

  ### Validation ###

  describe '#validation' do
    it { expect(instance).to be_valid }
  end # describe
end # describe
