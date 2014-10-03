# spec/presenters/features/text_content_presenter_spec.rb

require 'rails_helper'

require 'presenters/features/text_content_presenter'

RSpec.describe TextContentPresenter, :type => :decorator do
  let(:content)  { build(:text_content) }
  let(:instance) { described_class.new content }

  describe '#render_content' do
    let(:paragraph_tag) { %{<p>#{content.text_content}</p>} }


  end # describe

  describe '#text_content' do
    it { expect(instance).to have_reader(:text_content).with(content.text_content) }
  end # describe
end # describe
