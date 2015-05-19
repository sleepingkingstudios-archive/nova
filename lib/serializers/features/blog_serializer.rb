# lib/serializers/features/blog_serializer.rb

require 'serializers/features/feature_serializer'

class BlogSerializer < FeatureSerializer
  has_many :posts
end # class
