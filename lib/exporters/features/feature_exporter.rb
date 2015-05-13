# lib/exporters/features/feature_exporter.rb

require 'exporters/resource_exporter'

class FeatureExporter < ResourceExporter
  attributes :title, :slug, :slug_lock, :created_at, :updated_at

  def serialize resource, relations: :embedded, **options
    hsh = super

    hsh['_type'] = (resource._type || resource.class.name)

    hsh
  end # method serialize
end # module

# Autoload feature exporters to handle nested data structures.
Dir[Rails.root.join 'lib', 'exporters', 'features', '**', '*exporter.rb'].each do |file|
  require file
end # each
