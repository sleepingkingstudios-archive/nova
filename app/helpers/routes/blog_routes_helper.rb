# app/helpers/routes/blog_routes_helper.rb

module Routes
  module BlogRoutesHelper
    include Routes::ResourceRoutesHelper

    def blog_path resource
      resource_path resource
    end # method blog_path

    def create_blog_path directory
      create_resource_path directory, 'blogs'
    end # method create_blog_path

    def edit_blog_path resource
      edit_resource_path resource
    end # method edit_blog_path

    def index_blogs_path directory
      index_resources_path directory, 'blogs'
    end # method index_blogs_path

    def new_blog_path directory
      new_resource_path directory, 'blogs'
    end # method new_blog_path
  end # module
end # module
