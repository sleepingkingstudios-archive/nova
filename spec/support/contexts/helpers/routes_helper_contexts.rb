# spec/support/contexts/helpers/routes_helper_contexts.rb

module Spec
  module Contexts
    module Helpers
      module RoutesHelperContexts
        extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

        shared_context 'with a root directory' do
          let(:slug)      { 'weapons' }
          let(:directory) { build(:directory, :slug => slug) }
        end # shared_context

        shared_context 'with a root feature' do |feature_type|
          let(:slug)    { 'character-creation' }
          let(:feature) { build(feature_type, :slug => slug) }
        end # shared_context

        shared_context 'with a non-root directory' do
          let(:slugs) { %w(weapons swords japanese) }
          let(:directories) do
            [].tap do |ary|
              slugs.each do |slug|
                ary << create(:directory, :parent => ary[-1], :title => slug.capitalize)
              end # each
            end # tap
          end # let
        end # shared_context

        shared_context 'with a non-root feature' do |feature_type|
          let(:slugs) { %w(weapons swords japanese tachi) }
          let(:directories) do
            [].tap do |ary|
              slugs[0...-1].each do |slug|
                ary << create(:directory, :parent => ary[-1], :title => slug.capitalize)
              end # each
            end # tap
          end # let
          let(:feature) { build(feature_type, :slug => slugs.last, :directory => directories.last) }
        end # shared_context
      end # module
    end # module
  end # module
end # module
