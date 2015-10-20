# app/helpers/routes/page_routes_helper.rb

module Routes
  module PageRoutesHelper
    include Routes::ResourceRoutesHelper

    def create_page_path directory
      create_resource_path directory, 'pages'
    end # method create_page_path

    def edit_page_path resource
      edit_resource_path resource
    end # method edit_page_path

    def export_page_path resource, pretty: false
      export_resource_path resource, :pretty => pretty
    end # method export_page_path

    def index_pages_path directory
      index_resources_path directory, 'pages'
    end # method index_pages_path

    def new_page_path directory
      new_resource_path directory, 'pages'
    end # method new_page_path

    def page_path resource
      resource_path resource
    end # method page_path

    def preview_page_path directory
      preview_resource_path directory, 'pages'
    end # method preview_page_path

    def publish_page_path resource
      publish_resource_path resource
    end # method publish_page_path

    def unpublish_page_path resource
      unpublish_resource_path resource
    end # method unpublish_page_path
  end # module
end # module
