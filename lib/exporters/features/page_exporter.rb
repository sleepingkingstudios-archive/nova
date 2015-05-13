# lib/exporters/features/page_exporter.rb

require 'exporters/features/feature_exporter'

class PageExporter < FeatureExporter
  attribute :published_at

  embeds_one :content
end # class
