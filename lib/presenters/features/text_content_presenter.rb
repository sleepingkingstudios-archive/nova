# lib/presenters/features/text_content_presenter.rb

require 'presenters/features/content_presenter'

class TextContentPresenter < ContentPresenter
  delegate :text_content, :to => :content

  def render_content template
    line_break = '\r\n|\r|\n'
    paragraphs = text_content.split(/(#{line_break}){2,}/).reject { |str| str =~ /\A#{line_break}+\z/ }
    paragraphs.each do |paragraph|
      template.concat '<p>'.html_safe

      lines = paragraph.split(/\r\n|\r|\n/)
      lines.each.with_index do |line, index|
        template.concat '<br>'.html_safe unless index == 0
        template.concat line
      end # each

      template.concat '</p>'.html_safe
    end # each
    # template.concat(text_content)
  end # method render_content
end # class
