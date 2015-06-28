# lib/serializers/features/page_serializer.rb

require 'serializers/features/feature_serializer'

class PageSerializer < FeatureSerializer
  attribute :published_at

  embeds_one :content
end # class
