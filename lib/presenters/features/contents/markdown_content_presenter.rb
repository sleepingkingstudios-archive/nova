# lib/presenters/features/contents/markdown_content_presenter.rb 

require 'presenters/features/contents/text_content_presenter'

class MarkdownContentPresenter < TextContentPresenter
  def render_content template
    escaped_content  = CGI::escapeHTML text_content
    rendered_content = GitHub::Markdown.render_gfm escaped_content

    template.concat %{<div class="markdown">#{rendered_content.strip}</div>}.html_safe
  end # method render_content
end # class
