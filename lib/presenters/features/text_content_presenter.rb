# lib/presenters/features/text_content_presenter.rb

require 'presenters/features/content_presenter'

class TextContentPresenter < ContentPresenter
  delegate :text_content, :to => :content

  def render_content template
    return if text_content.blank?

    paragraphs = text_content.gsub(/\r\n|\r/,"\n").split(/\n{2,}/)
    paragraphs.each do |paragraph|
      template.concat '<p>'.html_safe

      lines = paragraph.split("\n")
      lines.each.with_index do |line, index|
        template.concat '<br>'.html_safe unless index == 0
        template.concat line
      end # each

      template.concat '</p>'.html_safe
    end # each
    # template.concat(text_content)
  end # method render_content
end # class
