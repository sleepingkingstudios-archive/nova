# lib/exporters/features/blog_exporter.rb

require 'exporters/features/feature_exporter'
require 'exporters/resource_exporter'

class BlogExporter < ResourceExporter.new(Blog)
  include FeatureExporter

  has_many :posts
end # class
