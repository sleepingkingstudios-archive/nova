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
      end # module
    end # module
  end # module
end # module
