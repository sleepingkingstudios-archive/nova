# spec/controllers/delegates/features/blogs_delegate_spec.rb

require 'rails_helper'

require 'delegates/features/blogs_delegate'

RSpec.describe BlogsDelegate, :type => :decorator do
  include Spec::Contexts::SerializerContexts
  include Spec::Contexts::Controllers::ResourcesContexts
  include Spec::Contexts::Delegates::DelegateContexts

  include Spec::Examples::SerializerExamples

  let(:object)   { build(:blog) }
  let(:instance) { described_class.new object }

  describe '::new' do
    it { expect(described_class).to construct.with(0..1).arguments }

    describe 'with no arguments' do
      let(:instance) { described_class.new }

      it 'sets the resource class' do
        expect(instance.resource_class).to be Blog
      end # it
    end # it
  end # describe

  ### Actions ###

  describe '#export' do
    include_context 'with a controller'

    let(:blacklisted_attributes) { %w(_id _type posts blog_id) }

    shared_examples 'should export the blog as JSON' do |proc|
      it 'should export the blog as JSON' do
        serialized = nil

        expect(controller).to receive(:render) do |options|
          expect(options).to have_key :json

          serialized = JSON.parse options[:json]
          expect(serialized).to be_a Hash
        end # expect

        perform_action

        expect_to_serialize_attributes serialized, blog

        SleepingKingStudios::Tools::ObjectTools.apply self, proc, serialized if proc.respond_to?(:call)
      end # it
    end # shared_examples

    let(:exporter) { Object.new.extend(ExportersHelper) }
    let(:request)  { double('request', :params => ActionController::Parameters.new({})) }

    def perform_action
      instance.export request
    end # method perform_action

    it { expect(instance).to respond_to(:export).with(1).argument }

    describe 'with a blog' do
      let(:blog)   { create(:blog) }
      let(:object) { blog }

      include_examples 'should export the blog as JSON', ->(serialized) {
        expect(serialized['posts']).to be_blank
      } # end examples

      context 'with many posts' do
        let!(:pages) { Array.new(3) { create(:blog_post, :content => build(:content), :blog => blog) } }

        include_examples 'should export the blog as JSON', ->(serialized) {
          expect_to_serialize_blog_posts serialized, blog
        } # end examples
      end # context
    end # describe
  end # describe
end # describe
