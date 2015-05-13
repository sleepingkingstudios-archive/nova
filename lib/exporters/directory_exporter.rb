# lib/exporters/directory_exporter.rb

require 'exporters/resource_exporter'
require 'exporters/features/feature_exporter'

class DirectoryExporter < ResourceExporter
  attributes :title, :slug, :slug_lock, :created_at, :updated_at

  has_many :directories
  has_many :features
end # class
