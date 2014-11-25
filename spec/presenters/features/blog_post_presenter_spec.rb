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

  describe '#error_messages' do
    it { expect(instance).to have_reader(:error_messages).with([]) }

    context 'with multiple error messages' do
      let(:errors) do
        [ "Title can't be blank",
          'Slug is already taken',
          "Streams can't be crossed"
        ] # end array
      end # let

      before(:each) do
        errors.each do |message|
          words = message.split(/\s+/)

          post.errors.add(words.shift.downcase, words.join(' '))
        end # each
      end # before each

      it { expect(instance.error_messages).to contain_exactly(*errors) }

      context 'with content error messages' do
        let(:attributes) { super().merge :content => build(:content) }
        let(:content_errors) do
          [ "Text content can't be blank",
            "Picture content depicts a weeping angel. Any representation of"\
            " an angel becomes an angel. Don't look away. Don't even blink."\
            "Blink and you're dead."
          ] # end array
        end # let
        let(:expected) do
          errors + content_errors
        end # let

        before(:each) do
          post.errors.add('content', 'is invalid')

          content_errors.each do |message|
            words = message.split(/\s+/)

            post.content.errors.add(words.shift.downcase, words.join(' '))
          end # each
        end # before each

        it { expect(instance.error_messages).to contain_exactly(*expected) }
      end # context
    end # context
  end # describe

  describe '#icon' do
    let(:expected) { %{<span class="fa fa-file-o"></span>} }

    it { expect(instance).to respond_to(:icon).with(0..1).arguments }

    it { expect(instance.icon).to be == expected }

    describe 'with options' do
      let(:expected) { %{<span class="fa fa-file-o fa-2x"></span>} }

      it { expect(instance.icon :scale => 2).to be == expected }
    end # describe
  end # describe

  describe '#name' do
    it { expect(instance).to have_reader(:name).with('Post') }
  end # describe

  describe '#post' do
    it { expect(instance).to have_reader(:post).with(post) }
  end # describe

  describe '#published_at' do
    it { expect(instance).to have_reader(:published_at).with_value(nil) }

    context 'with a #published_at date' do
      let(:attributes) { super().merge :published_at => 1.day.ago }

      it { expect(instance.published_at).to be == attributes[:published_at] }
    end # context
  end # describe

  describe '#published_message' do
    it { expect(instance).to have_reader(:published_message).with_value('Not Published') }

    context 'with #published_at date in the past' do
      let(:attributes) { super().merge :published_at => 1.day.ago }

      it { expect(instance.published_message).to be == "Published on #{attributes[:published_at].strftime '%A, %-d %B %Y'}." }
    end # context
  end # describe

  describe '#published_status' do
    it { expect(instance).to have_reader(:published_status).with_value('No') }

    context 'with #published_at date in the past' do
      let(:attributes) { super().merge :published_at => 1.day.ago }

      it { expect(instance.published_status).to be == 'Yes' }
    end # context
  end # describe

  describe '#published?' do
    it { expect(instance).to have_reader(:published?).with(false) }

    context 'with #published_at date in the past' do
      let(:attributes) { super().merge :published_at => 1.day.ago }

      it { expect(instance.published?).to be true }
    end # context

    context 'with #published_at date in the future' do
      let(:attributes) { super().merge :published_at => 1.day.from_now }

      it { expect(instance.published?).to be false }
    end # context
  end # describe
end # describe

