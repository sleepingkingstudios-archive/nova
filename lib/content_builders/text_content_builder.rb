# lib/content_builders/text_content_builder.rb

require 'content_builders/content_builder'

class TextContentBuilder < ContentBuilder
  def content_params params
    params.permit(:text_content)
  end # method content_params
end # class
