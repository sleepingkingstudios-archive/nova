# spec/exporters/features/blog_exporter_spec.rb

require 'rails_helper'

require 'exporters/features/blog_exporter'

RSpec.describe BlogExporter do
  let(:blacklisted_attributes) { %w(_id _type) }

  it { expect(described_class).to be_constructible.with(0).arguments }

  describe '::instance' do
    it { expect(described_class).to have_reader(:instance).with(be_a described_class) }
  end # describe

  describe '::resource_class' do
    it { expect(described_class).to have_reader(:resource_class).with(Blog) }
  end # describe

  describe '::deserialize' do
    shared_examples 'should return a blog' do
      it 'should return a blog' do
        expect(resource).to be_a Blog

        deserialized.each do |key, value|
          expect(attributes[key]).to be == value
        end # each

        expect(deserialized.keys).to contain_exactly *(attributes.keys - blacklisted_attributes)
      end # it
    end # shared_examples

    let(:attributes)   { build(:blog).attributes.stringify_keys }
    let(:resource)     { described_class.deserialize attributes }
    let(:deserialized) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }

    it { expect(described_class).to respond_to(:deserialize).with(1).argument }

    it 'should not create a blog' do
      expect { described_class.deserialize attributes }.not_to change(Blog, :count)
    end # it

    include_examples 'should return a blog'

    describe 'with persist => true' do
      it 'should create a blog' do
        expect { described_class.deserialize attributes, :persist => true }.to change(Blog, :count).by(1)
      end # it
    end # describe

    describe 'with attributes for posts' do
      let(:content_attributes) { build(:text_content).attributes.stringify_keys }
      let(:posts_attributes)   { Array.new(3) { build(:blog_post).attributes.merge(:content => content_attributes).stringify_keys } }

      let(:blacklisted_attributes) { super().concat %w(posts) }

      before(:each) { attributes['posts'] = posts_attributes }

      it 'should not create a blog' do
        expect { described_class.deserialize attributes }.not_to change(Blog, :count)
      end # it

      it 'should not create blog posts' do
        expect { described_class.deserialize attributes }.not_to change(BlogPost, :count)
      end # it

      include_examples 'should return a blog'

      it 'should return a blog with an array of posts' do
        posts = resource.posts.to_a
        expect(posts.count).to be == posts_attributes.count

        posts_attributes.each do |post_attributes|
          post = posts.find { |post| post.title == post_attributes['title'] }
          expect(post).to be_a BlogPost
          expect(post.blog).to be == resource
          expect(post.content).to be_a TextContent

          # Validate the built blog post.
          deserialized = post.attributes.reject { |key, _| ['_id', '_type', 'blog_id', 'content'].include?(key.to_s) }
          deserialized.each do |key, value|
            expect(post_attributes[key]).to be == value
          end # each
          expect(deserialized.keys).to contain_exactly *(post_attributes.keys - ['_id', '_type', 'blog_id', 'content'])

          # Validate the built blog post's content.
          deserialized = post.content.attributes.reject { |key, _| ['_id', '_type'].include?(key.to_s) }
          deserialized.each do |key, value|
            expect(post_attributes['content'][key]).to be == value
          end # each
          expect(deserialized.keys).to contain_exactly *(post_attributes['content'].keys - ['_id', '_type'])
        end # each
      end # it

      describe 'with persist => true' do
        it 'should create a blog' do
          expect { described_class.deserialize attributes, :persist => true }.to change(Blog, :count).by(1)
        end # it

        it 'should create posts' do
          expect { described_class.deserialize attributes, :persist => true }.to change(BlogPost, :count).by(posts_attributes.count)
        end # it
      end # describe
    end # describe
  end # describe

  describe '::serialize' do
    shared_examples 'should return the blog attributes' do
      it 'should return the blog attributes' do
        expect(serialized).to be_a Hash

        attributes.each do |key, value|
          expect(serialized[key]).to be == resource.send(key)
        end # each
      end # it
    end # shared_examples

    let(:resource)   { build(:blog) }
    let(:attributes) { resource.attributes.reject { |key, _| blacklisted_attributes.include?(key.to_s) } }
    let(:serialized) { described_class.serialize(resource) }

    it { expect(described_class).to respond_to(:serialize).with(1).argument }

    it { expect(described_class.serialize(resource).keys).to contain_exactly '_type', *attributes.keys }

    include_examples 'should return the blog attributes'

    describe 'with :relations => :all' do
      let(:serialized) { described_class.serialize(resource, :relations => :all) }

      include_examples 'should return the blog attributes'

      it { expect(serialized.keys).to contain_exactly '_type', 'posts', *attributes.keys }

      it { expect(serialized.fetch('posts')).to be == [] }
    end # describe

    describe 'with many posts' do
      let(:resource) { super().tap &:save! }
      let!(:posts)   { Array.new(3) { create(:blog_post, :blog => resource, :content => build(:content)) } }

      include_examples 'should return the blog attributes'

      it { expect(described_class.serialize(resource).keys).to contain_exactly '_type', *attributes.keys }

      describe 'with :relations => :all' do
        let(:serialized) { described_class.serialize(resource, :relations => :all) }
        let(:expected) do
          exporter = BlogPostExporter
          posts.map { |post| exporter.serialize(post) }
        end # let

        include_examples 'should return the blog attributes'

        it { expect(serialized.keys).to contain_exactly '_type', 'posts', *attributes.keys }

        it { expect(serialized.fetch('posts')).to contain_exactly *expected }
      end # describe
    end # describe
  end # describe
end # describe
