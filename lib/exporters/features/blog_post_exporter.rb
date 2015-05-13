# lib/exporters/features/blog_post_exporter.rb

require 'exporters/features/feature_exporter'

class BlogPostExporter < FeatureExporter
  attribute :published_at

  embeds_one :content
end # class
