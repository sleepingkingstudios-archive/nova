# lib/serializers/directory_serializer.rb

require 'serializers/resource_serializer'

class DirectorySerializer < ResourceSerializer
  attributes :title, :slug, :slug_lock, :created_at, :updated_at

  has_many :features

  def deserialize attributes, type: nil, **options
    resource = super

    deserialize_directories(resource, attributes, **options)

    resource
  end # method deserialize

  def serialize resource, recursive: false, relations: :embedded, **options
    hsh = super

    hsh.merge! serialize_directories(resource, :recursive => recursive, :relations => relations, **options) if recursive

    hsh
  end # method serialize

  private

  def deserialize_directories resource, attributes, **options
    directory_attrs = attributes['directories']

    return if directory_attrs.blank?

    directory_attrs.each do |hsh|
      serializer = decorator_class(hsh.stringify_keys.fetch('_type'), 'Serializer')
      resource.directories << serializer.deserialize(hsh, **options)
    end # each
  end # method deserialize_directories

  def serialize_directories resource, **options
    hsh      = {}
    relation = resource.directories

    return hsh if relation.empty?

    hsh['directories'] = relation.map do |obj|
      serializer = decorator_class(obj, 'Serializer')
      serializer.serialize(obj, **options)
    end # map

    hsh
  end # method serialize_directories
end # class
