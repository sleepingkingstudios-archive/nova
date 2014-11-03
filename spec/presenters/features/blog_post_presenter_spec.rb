# spec/presenters/features/blog_post_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/blog_post_presenter'

RSpec.describe BlogPostPresenter, :type => :decorator do
  shared_context 'with a blog' do
    let(:blog)       { create(:blog) }
    let(:attributes) { super().merge :blog => blog }
  end # shared_context

  let(:attributes) { {} }
  let(:post)       { build(:blog_post, attributes) }
  let(:instance)   { described_class.new post }

  describe '#blog' do
    it { expect(instance).to have_reader(:blog).with(nil) }

    context 'with a blog' do
      include_context 'with a blog'

      it { expect(instance.blog).to be == blog }
    end # context
  end # describe

  describe '#post' do
    it { expect(instance).to have_reader(:post).with(post) }
  end # describe
end # describe

