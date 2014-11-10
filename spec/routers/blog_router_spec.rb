# spec/routers/blog_router_spec.rb

require 'rails_helper'

require 'routers/blog_router'

RSpec.describe BlogRouter, :type => :decorator do
  shared_context 'with one missing routing parameter' do
    let(:search)  { 'weapons/swords/japanese/tachi'.split('/') }
    let(:found) do
      search[0..2].map { |slug| double('directory', :slug => slug) }
    end # let
    let(:missing) { search[3..3] }
  end # shared_context

  shared_context 'with many missing routing parameters' do
    let(:search)  { 'weapons/swords/japanese/tachi'.split('/') }
    let(:found) do
      search[0..0].map { |slug| double('directory', :slug => slug) }
    end # let
    let(:missing) { search[1..3] }
  end # shared_context

  shared_context 'with many posts' do
    let(:blog)       { super().tap { |blog| blog.try(:save!) } }
    let(:post_slugs) { %w(katana wakizashi tachi) }
    let!(:posts) do
      post_slugs.map { |slug| create(:blog_post, :blog => blog, :slug => slug, :content => build(:content)) }
    end # let
  end # shared_context

  let(:blog)     { build(:blog) }
  let(:instance) { described_class.new blog }

  describe '#blog' do
    it { expect(instance).to have_reader(:blog).with(blog) }
  end # describe

  describe '#route_to' do
    def perform_action
      instance.route_to search, found, missing
    end # method perform_action

    context 'with no posts' do
      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        it { expect(perform_action).to be nil }
      end # context

      context 'with many missing routing parameters' do
        include_context 'with many missing routing parameters'

        it { expect(perform_action).to be nil }
      end # context
    end # context

    context 'with many posts' do
      include_context 'with many posts'

      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        it { expect(perform_action).to be == posts.last }
      end # context

      context 'with many missing routing parameters' do
        let(:post_slugs) { %w(bows polearms swords) }
        let(:post)       { posts.select { |post| post.slug == search[1] }.first }

        include_context 'with many missing routing parameters'

        it { expect(perform_action).to be nil }

        it 'updates the routing parameters' do
          perform_action

          expect(instance.search).to be  == search
          expect(instance.found).to be   == found + [post]
          expect(instance.missing).to be == missing[1..-1]
        end # it
      end # context
    end # context
  end # describe

  describe '#route_to!' do
    shared_examples 'raises an error' do
      it 'raises an error' do
        expect { perform_action }.to raise_error Appleseed::ResourcesNotFoundError do |exception|
          expect(exception.search).to be  == search
          expect(exception.found).to be   == found
          expect(exception.missing).to be == missing
        end # raise_error
      end # it
    end # shared examples

    def perform_action
      instance.route_to! search, found, missing
    end # method perform_action

    context 'with no posts' do
      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        expect_behavior 'raises an error'
      end # context

      context 'with many missing routing parameters' do
        include_context 'with many missing routing parameters'

        expect_behavior 'raises an error'
      end # context
    end # context

    context 'with many posts' do
      include_context 'with many posts'

      context 'with one missing routing parameter' do
        include_context 'with one missing routing parameter'

        it { expect(perform_action).to be == posts.last }
      end # context

      context 'with many missing routing parameters' do
        include_context 'with many missing routing parameters'

        expect_behavior 'raises an error'
      end # context
    end # context
  end # describe
end # describe
