# spec/models/features/blog_spec.rb

require 'rails_helper'

RSpec.describe Blog, :type => :model do
  shared_context 'with many posts' do
    let!(:posts) do
      Array.new(3).map.with_index do |_, index|
        create(:blog_post, :blog => instance, :content => build(:content), :published_at => (3 - index).days.ago)
      end # map
    end # let!
  end # shared_context

  let(:attributes) { attributes_for(:blog) }
  let(:instance)   { described_class.new attributes }

  ### Relations ###

  describe '#posts' do
    it { expect(instance).to have_reader(:posts).with([]) }

    describe 'with many posts' do
      include_context 'with many posts'

      it { expect(instance.posts).to contain_exactly(*posts) }
    end # describe
  end # describe

  ### Validation ###

  describe '#validation' do
    it { expect(instance).to be_valid }
  end # describe

  ### Instance Methods ###

  describe '#first_published' do
    it { expect(instance).to have_reader(:first_published).with_value(nil) }

    describe 'with many posts' do
      include_context 'with many posts'

      it { expect(instance.first_published).to be == posts.first }
    end # describe
  end # describe

  describe '#last_published' do
    it { expect(instance).to have_reader(:last_published).with_value(nil) }

    describe 'with many posts' do
      include_context 'with many posts'

      it { expect(instance.last_published).to be == posts.last }
    end # describe
  end # describe
end # describe
