# spec/presenters/features/contents/text_content_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/contents/text_content_presenter'

RSpec.describe TextContentPresenter, :type => :decorator do
  let(:content)  { build(:text_content) }
  let(:instance) { described_class.new content }

  describe '#render_content' do
    let(:output_buffer) { '' }
    let(:paragraph_tag) { %{<p>#{content.text_content}</p>} }
    let(:template) do
      double(:template).tap do |mock|
        allow(mock).to receive(:concat) { |str| output_buffer << str }
      end # tap
    end # let

    it 'wraps the content in <p> tags' do
      instance.render_content template

      expect(output_buffer).to be == paragraph_tag
    end # it

    context 'with complex multi-line content' do
      let(:text_lines) do
        [ 'There was a knight who longed to wield a more impressive lance,',
          'To carry into battle and to aid him in romance.',
          '',
          'A wizard overheard the knight and granted his request,',
          'At first, the knight was overjoyed to see how he was blessed.'
        ] # end array
      end # let
      let(:text_content) { text_lines.join "\r\n" }
      let(:content)      { build(:text_content, :text_content => text_content) }
      let(:paragraph_tag) do
        %{<p>#{text_lines[0..1].join('<br>')}</p><p>#{text_lines[3..4].join('<br>')}</p>}
      end # let

      it 'wraps the content in <p> tags by paragraph and adds <br> line breaks' do
        instance.render_content template

        expect(output_buffer).to be == paragraph_tag
      end # it
    end # context
  end # describe

  describe '#text_content' do
    it { expect(instance).to have_reader(:text_content).with(content.text_content) }
  end # describe
end # describe
