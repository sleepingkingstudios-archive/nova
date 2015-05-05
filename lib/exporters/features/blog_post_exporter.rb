# lib/exporters/features/blog_post_exporter.rb

require 'exporters/resource_exporter'

class BlogPostExporter < ResourceExporter.new(BlogPost)
  attributes :title, :slug, :slug_lock

  embeds_one :content
end # class
