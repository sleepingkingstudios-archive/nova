# lib/exporters/features/blog_exporter.rb

require 'exporters/resource_exporter'

class BlogExporter < ResourceExporter.new(Blog)
  attributes :title, :slug, :slug_lock

  has_many :posts
end # class
