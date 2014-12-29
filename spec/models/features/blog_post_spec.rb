# spec/models/features/blog_post_spec.rb

require 'rails_helper'

RSpec.describe BlogPost, :type => :model do
  shared_context 'with a blog' do
    let(:blog_attrs) { {} }
    let(:blog)       { create(:blog, blog_attrs) }
    let(:attributes) { super().merge :blog => blog }
  end # shared_context

  shared_context 'with many directories' do
    let(:directories) do
      [].tap do |ary|
        3.times { |index| ary << create(:directory, :parent => ary[index - 1]) }
      end # tap
    end # let
    let(:directory)  { directories.last }
    let(:blog_attrs) { super().merge :directory => directory }
  end # shared_context

  shared_context 'with many sibling posts' do
    include_context 'with a blog'

    let!(:posts) do
      Array.new(3).map.with_index do |_, index|
        create :blog_post, :blog => blog, :content => build(:content), :published_at => (6-2*index).days.ago
      end # let
    end # let
  end # shared_context

  shared_context 'with generic content' do
    let(:content)    { build :content }
    let(:attributes) { super().merge :content => content }
  end # shared_context

  let(:attributes) { attributes_for(:blog_post) }
  let(:instance)   { described_class.new attributes }

  ### Class Methods ###

  describe '::default_content_type' do
    it { expect(described_class).to have_reader(:default_content_type).with(:text) }
  end # describe

  describe '::first_published' do
    include_context 'with many sibling posts'

    it { expect(described_class).to respond_to(:first_published).with(1).argument }

    it 'returns the first post in the blog' do
      expect(described_class.first_published blog).to be == posts.first
    end # it
  end # describe

  describe '::last_published' do
    include_context 'with many sibling posts'

    it { expect(described_class).to respond_to(:last_published).with(1).argument }

    it 'returns the last post in the blog' do
      expect(described_class.last_published blog).to be == posts.last
    end # it
  end # describe

  describe '::reserved_slugs' do
    it { expect(described_class).to have_reader(:reserved_slugs) }

    it { expect(described_class.reserved_slugs).to include 'admin' }

    it 'contains resourceful actions' do
      expect(described_class.reserved_slugs).to include *%w(
        index
        new
        edit
      ) # end array
    end # it

    it 'contains directory and feature names' do
      expect(described_class.reserved_slugs).to include *%w(
        directories
        features
      ) # end array
    end # it
  end # describe

  ### Attributes ###

  describe '#title' do
    it { expect(instance).to have_property(:title) }
  end # describe

  describe '#slug' do
    let(:value) { attributes_for(:page).fetch(:title).parameterize }

    it { expect(instance).to have_property :slug }

    it 'is generated from the title' do
      expect(instance.slug).to be == instance.title.parameterize
    end # it

    it 'sets #slug_lock to true' do
      expect { instance.slug = value }.to change(instance, :slug_lock).to(true)
    end # it
  end # describe

  describe '#slug_lock' do
    it { expect(instance).to have_property :slug_lock }
  end # describe

  describe '#published_at' do
    it { expect(instance).to have_property(:published_at) }

    it 'is set by #publish' do
      expect { instance.publish }.to change(instance, :published_at).to be_a ActiveSupport::TimeWithZone
    end # it
  end # describe

  describe '#published_order' do
    it { expect(instance).to have_reader(:published_order).with_value(nil) }

    context 'with a published post' do
      include_context 'with a blog'
      include_context 'with generic content'

      let(:attributes) { super().merge :blog => blog, :content => content }
      let(:instance)   { super().tap(&:publish).tap(&:save!) }

      it { expect(instance.published_order).to be == 0 }

      context 'with many sibling posts' do
        include_context 'with many sibling posts'

        it { expect(instance.published_order).to be == posts.count }

        context 'with a back-dated post' do
          before(:each) do
            instance.published_at = 3.days.ago
            instance.save!
            posts.map &:reload
          end # before each

          it { expect(instance.published_order).to be == 2 }

          it { expect(posts.map &:published_order).to be == [0, 1, 3] }
        end # context
      end # context
    end # context
  end # describe

  ### Relations ###

  describe '#blog' do
    it { expect(instance).to have_reader(:blog_id).with(nil) }

    it { expect(instance).to have_reader(:blog).with(nil) }

    context 'with a blog' do
      include_context 'with a blog'

      it 'sets the blog' do
        expect(instance.blog).to be == blog
      end # it

      it 'sets the blog id' do
        expect(instance.blog_id).to be == blog.id
      end # it
    end # context
  end # describe

  describe '#content' do
    it { expect(instance).to have_reader(:content).with(nil) }

    context 'with generic content' do
      include_context 'with generic content'

      it { expect(instance.content).to be == content }
    end # context
  end # describe

  ### Validation ###

  describe '#validation' do
    context 'with a blog' do
      include_context 'with a blog'

      context 'with generic content' do
        include_context 'with generic content'

        it { expect(instance).to be_valid }
      end # context
    end # context

    describe 'blog must be present' do
      let(:attributes) { super().merge :blog => nil }

      it { expect(instance).to have_errors.on(:blog).with_message("can't be blank") }
    end # describe

    describe 'content must be present' do
      let(:attributes) { super().merge :content => nil }

      it { expect(instance).to have_errors.on(:content).with_message("can't be blank") }
    end # describe

    describe 'title must be present' do
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:title).with_message("can't be blank") }
    end # describe

    describe 'slug must be present' do
      let(:attributes) { super().merge :title => nil }

      it { expect(instance).to have_errors.on(:slug).with_message("can't be blank") }
    end # describe

    describe 'slug must not match reserved values' do
      context 'with "admin"' do
        let(:attributes) { super().merge :slug => 'admin' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context

      context 'with "index"' do
        let(:attributes) { super().merge :slug => 'index' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context

      context 'with "edit"' do
        let(:attributes) { super().merge :slug => 'edit' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context

      context 'with "directories"' do
        let(:attributes) { super().merge :slug => 'directories' }

        it { expect(instance).to have_errors.on(:slug).with_message("is reserved") }
      end # context
    end # describe

    describe 'slug must be unique within blog scope' do
      context 'with a blog' do
        include_context 'with a blog'

        context 'with a sibling post' do
          before(:each) { create(:blog_post, :blog => blog, :content => build(:content), :slug => instance.slug) }

          it { expect(instance).to have_errors.on(:slug).with_message('is already taken') }
        end # context

        context 'with an unrelated post' do
          before(:each) { create(:blog_post, :blog => create(:blog), :content => build(:content), :slug => instance.slug) }

          it { expect(instance).not_to have_errors.on(:slug) }
        end # context
      end # context
    end # describe
  end # describe

  ### Instance Methods ###

  describe '#first_published' do
    include_context 'with a blog'
    include_context 'with generic content'
    include_context 'with many sibling posts'

    before(:each) do
      instance.content = content
      instance.published_at = 3.days.ago
      instance.save!
      posts.map &:reload
    end # before each

    it { expect(instance).to have_reader(:first_published).with(posts.first) }

    context 'with a cached value' do
      before(:each) { instance.first_published }

      it 'does not query the datastore' do
        expect(BlogPost).not_to receive(:all)

        expect(instance.first_published).to be == posts.first
      end # it
    end # context
  end # describe

  describe '#last_published' do
    include_context 'with a blog'
    include_context 'with generic content'
    include_context 'with many sibling posts'

    before(:each) do
      instance.content = content
      instance.published_at = 3.days.ago
      instance.save!
      posts.map &:reload
    end # before each

    it { expect(instance).to have_reader(:last_published).with(posts.last) }

    context 'with a cached value' do
      before(:each) { instance.last_published }

      it 'does not query the datastore' do
        expect(BlogPost).not_to receive(:all)

        expect(instance.last_published).to be == posts.last
      end # it
    end # context
  end # describe

  describe '#next_published' do
    include_context 'with a blog'
    include_context 'with generic content'
    include_context 'with many sibling posts'

    before(:each) do
      instance.content = content
      instance.published_at = 3.days.ago
      instance.save!
      posts.map &:reload
    end # before each

    it { expect(instance).to have_reader(:next_published).with(posts.last) }

    context 'with a cached value' do
      before(:each) { instance.next_published }

      it 'does not query the datastore' do
        expect(BlogPost).not_to receive(:all)

        expect(instance.next_published).to be == posts.last
      end # it
    end # context
  end # describe

  describe '#prev_published' do
    include_context 'with a blog'
    include_context 'with generic content'
    include_context 'with many sibling posts'

    before(:each) do
      instance.content = content
      instance.published_at = 3.days.ago
      instance.save!
      posts.map &:reload
    end # before each

    it { expect(instance).to have_reader(:prev_published).with(posts[1]) }

    context 'with a cached value' do
      before(:each) { instance.prev_published }

      it 'does not query the datastore' do
        expect(BlogPost).not_to receive(:all)

        expect(instance.prev_published).to be == posts[1]
      end # it
    end # context
  end # describe

  describe '#reload' do
    include_context 'with a blog'
    include_context 'with generic content'

    context 'with cached ordering values' do
      before(:each) do
        instance.blog    = blog
        instance.content = content
        instance.save!
        instance.instance_variable_set :@first_published, double('published post')
      end # before each

      it 'clears the cached ordering values' do
        expect {
          instance.reload
        }.to change {
          instance.instance_variable_get(:@first_published)
        }.to nil
      end # it
    end # context
  end # describe

  describe '#to_partial_path' do
    it { expect(instance).to respond_to(:to_partial_path).with(0).arguments }

    it { expect(instance.to_partial_path).to be == '/' }

    describe 'with a blog' do
      include_context 'with a blog'

      let(:slugs) { [blog.slug, instance.slug] }

      it { expect(instance.to_partial_path).to be == slugs.join('/') }

      context 'with an empty slug' do
        let(:attributes) { super().merge :slug => nil }
        let(:slugs)      { super()[0...-1] }

        it { expect(instance.to_partial_path).to be == slugs.join('/') }
      end # context

      describe 'with many directories' do
        include_context 'with many directories'

        let(:slugs) { [*directories.map(&:slug), blog.slug, instance.slug] }

        it { expect(instance.to_partial_path).to be == slugs.join('/') }

        context 'with an empty slug' do
          let(:attributes) { super().merge :slug => nil }
          let(:slugs)      { super()[0...-1] }

          it { expect(instance.to_partial_path).to be == slugs.join('/') }
        end # context
      end # describe
    end # describe
  end # describe
end # describe
