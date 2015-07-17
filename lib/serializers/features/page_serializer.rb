# lib/serializers/features/page_serializer.rb

require 'serializers/features/directory_feature_serializer'

class PageSerializer < DirectoryFeatureSerializer
  attribute :published_at

  embeds_one :content
end # class
