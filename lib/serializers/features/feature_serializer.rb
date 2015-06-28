# lib/serializers/features/feature_serializer.rb

require 'serializers/resource_serializer'

class FeatureSerializer < ResourceSerializer
  attributes :title, :slug, :slug_lock, :created_at, :updated_at
end # class
