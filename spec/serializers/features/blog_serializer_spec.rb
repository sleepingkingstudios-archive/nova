# spec/serializers/features/blog_serializer_spec.rb

require 'rails_helper'

require 'serializers/features/blog_serializer'

RSpec.describe BlogSerializer do
  include Spec::Contexts::SerializerContexts
  include Spec::Examples::SerializerExamples

  include_context 'with a serializer for', Blog

  before(:each) { blacklisted_attributes << 'posts' }

  describe '#deserialize' do
    it { expect(instance).to respond_to(:deserialize).with(1, :arbitrary, :keywords) }

    before(:each) { expected.merge! 'slug' => attributes[:title].parameterize, 'slug_lock' => false }

    include_examples 'should return an instance of the resource'

    it 'should not persist the blog' do
      expect { instance.deserialize attributes, **options }.not_to change(resource_class, :count)
    end # it

    describe 'with :persist => true' do
      before(:each) { options[:persist] = true }

      it 'should persist the blog' do
        expect { instance.deserialize attributes, **options }.to change(resource_class, :count).by(1)
      end # it
    end # describe

    describe 'with attributes for many posts' do
      let(:blog_posts_attributes) do
        Array.new(3) do
          attributes_for(:blog_post,
            :_type   => 'BlogPost',
            :content => attributes_for(:content, :_type => 'Content')
          ) # end attributes
        end # array
      end # let

      before(:each) { attributes['posts'] = blog_posts_attributes }

      include_examples 'should return an instance of the resource', ->() {
        posts = resource.posts.to_a
        expect(posts.count).to be == blog_posts_attributes.count
        expect(posts.map &:title).to contain_exactly *blog_posts_attributes.map { |hsh| hsh[:title] }
      } # end examples

      it 'should not persist the blog' do
        expect { instance.deserialize attributes, **options }.not_to change(resource_class, :count)
      end # it

      it 'should not persist the posts' do
        expect { instance.deserialize attributes, **options }.not_to change(BlogPost, :count)
      end # it

      describe 'with :persist => true' do
        before(:each) { options[:persist] = true }

        it 'should persist the blog' do
          expect { instance.deserialize attributes, **options }.to change(resource_class, :count).by(1)
        end # it

        it 'should persist the posts' do
          expect { instance.deserialize attributes, **options }.to change(BlogPost, :count).by(blog_posts_attributes.count)
        end # it
      end # describe
    end # describe
  end # describe

  describe '#serialize' do
    it { expect(instance).to respond_to(:serialize).with(1, :arbitrary, :keywords) }

    include_examples 'should return the resource attributes'

    context 'with many posts' do
      let(:blog_posts) { Array.new(3) { create(:blog_post, :blog => resource, :content => build(:content)) } }

      before(:each) { blog_posts.each { |post| resource.posts << post } }

      include_examples 'should return the resource attributes', ->() {
        expect(serialized['posts']).to be_blank
      } # end examples

      describe 'with :relations => :all' do
        before(:each) { options[:relations] = :all }

        include_examples 'should return the resource attributes', ->() {
          expect(serialized).to have_key 'posts'

          posts = serialized.fetch('posts')
          expect(posts).to be_a Array
          expect(posts.count).to be == blog_posts.count

          blog_posts.each do |post|
            expect(posts).to include BlogPostSerializer.serialize(post)
          end # each
        } # end examples
      end # describe
    end # context
  end # describe
end # describe
