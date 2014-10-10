# spec/errors/resources_not_found_error_spec.rb

require 'rails_helper'

require 'errors/resources_not_found_error'

RSpec.describe Appleseed::ResourcesNotFoundError do
  let(:search)   { %w(weapons swords japanese tachi) }
  let(:found)    { search[0..2].map { |slug| double('directory', :slug => slug) } }
  let(:missing)  { search[3..-1] }
  let(:instance) { described_class.new search, found, missing }

  describe '::new' do
    it { expect(described_class).to construct.with(3).arguments }
  end # describe

  describe '#search' do
    it { expect(instance).to have_reader(:search).with(search) }
  end # describe

  describe '#found' do
    it { expect(instance).to have_reader(:found).with(found) }
  end # describe

  describe '#missing' do
    it { expect(instance).to have_reader(:missing).with(missing) }
  end # describe

  describe '#message' do
    let(:expected) do
      str = <<-MESSAGE
Problem:
  Resource(s) not found with path #{search.join('/').inspect}.
Summary:
  The path array must match a valid chain of directories originating at a root directory, with the final path segment(s) representing the resource or nested resources being searched for. The search was for the slug(s): #{search.join(', ')} ... (#{search.count} total) and the following resource(s) were not found: #{missing.join ', '} ... (#{missing.count} total).
Resolution:
  Ensure that the resources exist in the database by navigating to the containing directory at #{found.join('/')} and inspecting the #features and #children relations.
MESSAGE
      str.strip
    end # let

    it { expect(instance).to have_reader(:message).with(expected) }
  end # describe
end # describe
