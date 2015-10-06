# spec/support/contexts/controllers/resources_contexts.rb

module Spec
  module Contexts
    module Controllers
      module ResourcesContexts
        extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

        shared_context 'with an empty path' do
          let(:path)        { nil }
          let(:directories) { [] }
        end # shared_context

        shared_context 'with an invalid path' do
          let(:segments) { %w(weapons swords japanese) }
          let(:path)     { segments.join('/') }
          let!(:directories) do
            [].tap do |ary|
              segments[0...-1].each do |segment|
                ary << create(:directory, :parent => ary[-1], :title => segment.capitalize)
              end # each
            end # tap
          end # let!
        end # shared_context

        shared_context 'with the root path' do
          let(:path)     { '/' }
          let(:resource) { RootDirectory.instance }
        end # shared_context

        shared_context 'with a valid path to a directory' do
          let(:segments) { %w(weapons swords japanese) }
          let(:path)     { segments.join('/') }
          let!(:directories) do
            [].tap do |ary|
              segments.each do |segment|
                ary << create(:directory, :parent => ary[-1], :title => segment.capitalize)
              end # each
            end # tap
          end # let!
        end # shared_context

        shared_context 'with a valid path to a feature' do
          include_context 'with a valid path to a directory'

          let(:path) { segments.push(resource.slug).join('/') }
        end # shared_context

        shared_context 'with a valid path to a blog' do
          include_context 'with a valid path to a feature'

          let(:resource_name) { :blog }
          let!(:resource)     { create(:blog, :directory => directories.last) }
        end # shared_context

        shared_context 'with a valid path to a blog post' do
          include_context 'with a valid path to a feature'

          let(:resource_name) { :post }
          let(:blog)          { create(:blog, :directory => directories.last) }
          let!(:resource)     { create(:blog_post, :blog => blog, :content => build(:content)) }
          let(:path)          { segments.push(blog.slug, resource.slug).join('/') }
        end # shared_context

        shared_context 'with a valid path to a page' do
          include_context 'with a valid path to a feature'

          let(:resource_name) { :page }
          let!(:resource)     { create(:page, :directory => directories.last, :content => build(:content)) }
        end # shared_context
      end # module
    end # module
  end # module
end # module
