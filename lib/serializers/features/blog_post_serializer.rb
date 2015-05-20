# lib/serializers/features/blog_post_serializer.rb

require 'serializers/features/feature_serializer'

class BlogPostSerializer < FeatureSerializer
  attributes :published_at, :published_order

  embeds_one :content

  private

  def deserialize_attributes resource, attributes, **options
    deserialize_attribute resource, :blog_id, attributes[:blog_id] if attributes.key?(:blog_id)

    super
  end # method deserialize_attributes
end # class
