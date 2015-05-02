# lib/exporters/features/contents/text_content_exporter.rb

require 'exporters/resource_exporter'

class TextContentExporter < ResourceExporter.new(TextContent)
  attributes :_type, :text_content
end # class
