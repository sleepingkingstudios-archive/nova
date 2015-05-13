# lib/exporters/features/blog_exporter.rb

require 'exporters/features/feature_exporter'

class BlogExporter < FeatureExporter
  has_many :posts
end # class
