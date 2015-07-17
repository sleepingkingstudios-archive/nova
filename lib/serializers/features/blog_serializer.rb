# lib/serializers/features/blog_serializer.rb

require 'serializers/features/directory_feature_serializer'

class BlogSerializer < DirectoryFeatureSerializer
  has_many :posts
end # class
