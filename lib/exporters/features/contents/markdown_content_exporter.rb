# lib/exporters/features/contents/markdown_content_exporter.rb

require 'exporters/resource_exporter'

class MarkdownContentExporter < ResourceExporter.new(MarkdownContent)
  attribute :text_content
end # class
