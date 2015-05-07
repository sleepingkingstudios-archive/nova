# lib/exporters/features/feature_exporter.rb

module FeatureExporter
  def self.included other
    other.send :attributes, :title, :slug, :slug_lock, :created_at, :updated_at
  end # method included
end # module
