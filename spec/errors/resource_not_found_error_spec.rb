# spec/errors/resource_not_found_error_spec.rb

require 'rails_helper'

require 'errors/resource_not_found_error'

RSpec.describe Nova::ResourceNotFoundError do
  let(:search)   { %w(weapons swords japanese tachi) }
  let(:found)    { %w(weapons swords japanese).map { |slug| double('directory', :slug => slug) } }
  let(:missing)  { 'tachi' }
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
  Resource not found with path #{search.join('/').inspect}.
Summary:
  The path array must match a valid chain of directories originating at a root directory, with the final path segment representing the resource being searched for. The search was for the slug(s): #{search.join(', ')} ... (#{search.count} total) and the resource with slug \"#{missing}\" was not found.
Resolution:
  Ensure that the resource exists in the database by navigating to the containing directory at #{found.join('/')} and inspecting the #features and #children relations.
MESSAGE
      str.strip
    end # let

    it { expect(instance).to have_reader(:message).with(expected) }
  end # describe
end # describe
