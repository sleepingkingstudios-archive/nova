# lib/exporters/features/contents/text_content_exporter.rb

require 'exporters/resource_exporter'

class TextContentExporter < ResourceExporter.new(TextContent)
  attribute :text_content
end # class
