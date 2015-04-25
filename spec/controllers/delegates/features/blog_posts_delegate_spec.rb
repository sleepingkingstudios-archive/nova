# spec/controllers/delegates/features/blog_posts_delegate_spec.rb

require 'rails_helper'

require 'delegates/features/blog_posts_delegate'

RSpec.describe BlogPostsDelegate, :type => :decorator do
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  shared_context 'with a blog' do
    let(:blog)       { create(:blog) }
    let(:attributes) { super().merge :blog => blog }
  end # shared_context

  shared_context 'with request params' do
    let(:params) do
      ActionController::Parameters.new(
        :post => {
          :title => 'Some Title',
          :slug  => 'Some Slug',
          :evil  => 'malicious'
        } # end hash
      ) # end hash
    end # let
  end # shared_context

  shared_examples 'sanitizes feature attributes' do
    it 'whitelists feature attributes' do
      %w(title slug).each do |attribute|
        expect(sanitized[attribute]).to be == params.fetch(:post).fetch(attribute)
      end # each
    end # it

    it 'excludes unrecognized attributes' do
      expect(sanitized).not_to have_key 'evil'
    end # it
  end # shared_examples

  shared_examples 'sets the request' do
    it 'sets the request' do
      perform_action

      expect(instance.request).to be == request
    end # it
  end # shared_examples

  let(:attributes) { {} }
  let(:object)     { build(:blog_post, attributes) }
  let(:instance)   { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be BlogPost
      end # it
    end # it
  end # describe

  ### Instance Methods ###

  describe '#blog' do
    it { expect(instance).to have_property(:blog).with(nil) }

    context 'with a blog' do
      include_context 'with a blog'

      it { expect(instance.blog).to be == blog }
    end # context
  end # describe

  describe '#build_resource' do
    include_context 'with a blog'

    let(:params)  { ActionController::Parameters.new({}) }
    let(:request) { double('request', :params => ActionController::Parameters.new(params)) }

    def perform_action
      instance.build_resource instance.build_resource_params(params)
    end # method perform_action

    before(:each) { instance.request = request }

    it { expect(instance).to respond_to(:build_resource).with(1).argument }

    it 'creates the specified resource' do
      expect(perform_action).to be_a BlogPost
    end # it

    it "sets the resource's blog to the blog" do
      expect(perform_action.blog).to be == blog
    end # it

    it 'creates an embedded content' do
      object = perform_action

      expect(instance.resource).to be == object
      expect(instance.resource.content).to be_a TextContent
    end # it

    context 'with an implicit content type' do
      let(:params) { super().merge :post => { :content => { :_type => 'MarkdownContent' } } }

      it 'creates an embedded content' do
        object = perform_action

        expect(instance.resource.content).to be_a MarkdownContent
      end # it
    end # context

    context 'with an explicit content type' do
      let(:params) { super().merge :content_type => 'MarkdownContent' }

      it 'creates an embedded content' do
        object = perform_action

        expect(instance.resource.content).to be_a MarkdownContent
      end # it
    end # context
  end # describe

  describe '#build_resource_params' do
    include_context 'with request params'

    let(:directories) { [] }
    let(:sanitized)   { instance.build_resource_params params }

    before(:each) do
      instance.directories = directories
    end # before each

    expect_behavior 'sanitizes feature attributes'

    context 'with a blog' do
      include_context 'with a blog'

      it 'assigns blog => blog' do
        expect(sanitized[:blog]).to be == blog
      end # it
    end # context
  end # describe

  describe '#resource_name' do
    it { expect(instance.resource_name).to be == 'posts' }
  end # describe

  ### Actions ###

  describe '#new', :controller => true do
    let(:blog)    { create(:blog) }
    let(:request) { double('request', :params => ActionController::Parameters.new({})) }

    before(:each) { instance.blog = blog }

    it 'assigns @resource' do
      instance.new request

      expect(assigns.fetch(:resource)).to be_a BlogPost
      expect(assigns.fetch(:resource).blog).to be == blog
      expect(assigns.fetch(:resource).content).to be_a Content
    end # it
  end # describe

  describe '#preview', :controller => true do
    let(:blog)       { create(:blog) }
    let(:object)     { BlogPost }
    let(:attributes) { { :title => 'Blog Post Title', :slug => 'blog-post-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:post => attributes)) }

    before(:each) { instance.blog = blog }

    it 'assigns resource with attributes and content' do
      instance.preview request

      resource = assigns.fetch(:resource)
      expect(resource).to be_a BlogPost

      expect(resource.blog).to  be == blog

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)

      expect(resource.content).to be_a Content
    end # it
  end # describe

  describe '#create', :controller => true do
    let(:blog)       { create(:blog) }
    let(:object)     { BlogPost }
    let(:attributes) { { :title => 'Blog Post Title', :slug => 'blog-post-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:post => attributes)) }

    before(:each) { instance.blog = blog }

    it 'assigns resource with attributes and content' do
      instance.create request

      resource = assigns.fetch(:resource)
      expect(resource).to be_a BlogPost

      expect(resource.blog).to  be == blog

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)

      expect(resource.content).to be_a Content
    end # it

    describe 'with invalid params' do
      let(:attributes) { {} }

      it 'renders the new template' do
        expect(controller).to receive(:render).with(instance.new_template_path)

        instance.create request
      end # it

      it 'does not create a blog post' do
        expect { instance.create request }.not_to change(BlogPost, :count)
      end # it
    end # describe

    describe 'with valid params' do
      let(:post_attributes) { attributes_for(:blog_post) }
      let(:attributes)      { post_attributes.merge :content => attributes_for(:text_content).merge(:_type => 'text_content') }
      let(:created_post)    { BlogPost.where(post_attributes).first }

      it 'creates a blog post' do
        expect { instance.create request }.to change(BlogPost, :count).by(1)
      end # it

      it 'redirects to the blog post' do
        expect(controller).to receive(:redirect_to).with("/#{blog.to_partial_path}/#{attributes[:title].parameterize}")

        instance.create request

        expect(flash_messages[:success]).to be == "Post successfully created."
      end # it
    end # describe
  end # describe

  describe '#update', :controller => true do
    let(:blog)       { create(:blog) }
    let(:object)     { create(:blog_post, :blog => blog, :content => build(:text_content)) }
    let(:attributes) { { :title => 'Blog Post Title', :slug => 'blog-post-slug', :evil => 'malicious' } }
    let(:request)    { double('request', :params => ActionController::Parameters.new(:post => attributes)) }

    def perform_action
      instance.update request
    end # method perform_action

    it 'updates the resource attributes' do
      perform_action

      resource = assigns.fetch(:resource)
      expect(resource).to be == object

      expect(resource.blog).to  be == blog

      expect(resource.title).to be == attributes.fetch(:title)
      expect(resource.slug).to  be == attributes.fetch(:slug)
    end # it

    expect_behavior 'sets the request'

    describe 'with invalid params' do
      let(:attributes) { { :title => nil } }

      it 'renders the edit template' do
        expect(controller).to receive(:render).with(instance.edit_template_path)

        perform_action

        expect(flash_messages.now[:warning]).to be_blank
      end # it

      it 'does not update the resource' do
        expect { perform_action }.not_to change { object.reload.title }
      end # it

      describe 'with content params' do
        let(:attributes) { super().merge :content => { :text_content => 'This content is deceased! It is an ex-content!' } }

        it 'updates the content attributes' do
          perform_action

          resource = assigns.fetch(:resource)
          content  = resource.content

          expect(content.text_content).to be == attributes.fetch(:content).fetch(:text_content)
        end # it
      end # describe
    end # describe

    describe 'with valid params' do
      let(:attributes) { { :title => 'Page Title', :slug => object.slug } }

      it 'redirects to the index path' do
        expect(controller).to receive(:redirect_to).with(instance.send :_resource_path)

        perform_action

        expect(flash_messages[:success]).to be == "Post successfully updated."
      end # it

      it 'updates the resource' do
        expect { perform_action }.to change { object.reload.title }.to(attributes[:title])
      end # it

      describe 'with content params' do
        let(:attributes) { super().merge :content => { :text_content => 'This content is deceased! It is an ex-content!' } }

        it 'updates the content attributes' do
          perform_action

          resource = assigns.fetch(:resource)
          content  = resource.content

          expect(content.text_content).to be == attributes.fetch(:content).fetch(:text_content)
        end # it
      end # describe
    end # describe
  end # describe
end # describe
