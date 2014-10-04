# spec/presenters/features/contents/markdown_content_presenter_spec.rb 

require 'rails_helper'

require 'presenters/features/contents/markdown_content_presenter'

RSpec.describe MarkdownContentPresenter, :type => :decorator do
  let(:attributes) { {} }
  let(:content)    { build(:markdown_content, attributes) }
  let(:instance)   { described_class.new content }

  describe '#render_content' do
    let(:text_content)  { "# This is an <h1> tag\n\nThis is a paragraph." }
    let(:attributes)    { super().merge :text_content => text_content }
    let(:html_output)   { %{<div class="markdown"><h1>This is an &lt;h1&gt; tag</h1>\n\n<p>This is a paragraph.</p></div>} }
    let(:template)      { double(:template, :concat => nil) }

    it 'renders content as Markdown with escaped html' do
      expect(template).to receive(:concat).with(html_output)

      instance.render_content template
    end # it
  end # describe
end # describe
