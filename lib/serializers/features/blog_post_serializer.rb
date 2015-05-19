# lib/serializers/features/blog_post_serializer.rb

require 'serializers/features/feature_serializer'

class BlogPostSerializer < FeatureSerializer
  attributes :published_at, :published_order

  embeds_one :content
end # class
