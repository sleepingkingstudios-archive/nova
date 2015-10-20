# app/helpers/routes/blog_post_routes_helper.rb

module Routes
  module BlogPostRoutesHelper
    include Routes::ResourceRoutesHelper

    def blog_post_path resource
      resource_path resource
    end # method blog_post_path

    def create_blog_post_path blog
      create_resource_path blog, 'posts'
    end # method create_blog_post_path

    def edit_blog_post_path resource
      edit_resource_path resource
    end # method edit_blog_post_path

    def export_blog_post_path resource, pretty: false
      export_resource_path resource, :pretty => pretty
    end # method export_blog_post_path

    def index_blog_posts_path blog
      index_resources_path blog, 'posts'
    end # method index_blog_posts_path

    def new_blog_post_path blog
      new_resource_path blog, 'posts'
    end # method new_blog_post_path

    def preview_blog_post_path blog
      preview_resource_path blog, 'posts'
    end # method preview_page_path

    def publish_blog_post_path resource
      publish_resource_path resource
    end # method publish_blog_post_path

    def unpublish_blog_post_path resource
      unpublish_resource_path resource
    end # method publish_blog_post_path
  end # module
end # module
