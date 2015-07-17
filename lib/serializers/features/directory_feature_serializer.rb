# lib/serializers/features/directory_feature_serializer.rb

require 'serializers/features/feature_serializer'

class DirectoryFeatureSerializer < FeatureSerializer
  attribute :directory

  def directory
    serialize_directory(resource.directory)
  end # method directory

  private

  def deserialize_directory resource, directory_path, **options
    return if directory_path.blank?

    resource.directory = Directory.find_by_ancestry(directory_path.strip.split '/').last
  end # method deserialize_directory

  def deserialize_relations resource, attributes, **options
    deserialize_directory(resource, attributes['directory'])

    super
  end # method deserialize_relations

  def serialize_directory directory
    directory.blank? ? nil : directory.to_partial_path
  end # method serialize_directory
end # class
