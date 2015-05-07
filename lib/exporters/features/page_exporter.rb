# lib/exporters/features/page_exporter.rb

require 'exporters/features/feature_exporter'
require 'exporters/resource_exporter'

class PageExporter < ResourceExporter.new(Page)
  include FeatureExporter

  attribute :published_at

  embeds_one :content
end # class
