# spec/presenters/features/content_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/content_presenter'

RSpec.describe ContentPresenter, :type => :decorator do
  shared_context 'with a text content' do
    let(:content) { build(:text_content) }
  end # shared_context

  let(:content)  { build(:content) }
  let(:instance) { described_class.new content }

  describe '::select_options_for_content_type' do
    let(:options) do
      Content.content_types.map do |_, value|
        [value.content_type_name, value.to_s.underscore.pluralize]
      end.sort { |(u, _), (v, _)| u <=> v }
    end # let

    it { expect(described_class).to have_reader(:select_options_for_content_type).with(options) }
  end # describe

  describe '#content' do
    it { expect(instance).to have_reader(:content).with(content) }
  end # describe

  describe '#form_partial_path' do
    it { expect(instance).to have_reader(:form_partial_path).with('admin/features/contents/fields') }

    wrap_context 'with a text content' do
      it { expect(instance.form_partial_path).to be == 'admin/features/contents/text_contents/fields' }
    end # context
  end # describe

  describe '#render_content' do
    it { expect(instance).to respond_to(:render_content).with(1).argument }
  end # describe

  describe '#type' do
    it { expect(instance).to have_reader(:type).with('content') }

    wrap_context 'with a text content' do
      it { expect(instance.type).to be == 'text_content' }
    end # context

    context 'with a content class' do
      let(:content) { MarkdownContent }

      it { expect(instance.type).to be == 'markdown_content' }
    end # context
  end # describe
end # describe
