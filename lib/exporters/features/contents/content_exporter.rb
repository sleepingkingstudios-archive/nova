# lib/exporters/features/content_exporter.rb

require 'exporters/resource_exporter'

class ContentExporter < ResourceExporter
  def serialize resource, **options
    hsh = super

    hsh['_type'] = (resource._type || resource.class.name)

    hsh
  end # method serialize
end # module
