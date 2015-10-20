# app/helpers/routes/resource_routes_helper.rb

module Routes
  module ResourceRoutesHelper
    include Routes::DirectoryRoutesHelper

    def create_resource_path directory, resource
      index_resources_path directory, resource
    end # method create_resource_path

    def edit_resource_path resource
      Directory.join resource_path(resource), 'edit'
    end # method edit_resource_path

    def index_resources_path directory, resource
      resource_name = case resource
      when String
        resource
      when Class
        resource.name.to_s
      else
        resource.class.name.to_s
      end # resource_name

      Directory.join directory_path(directory), resource_name.tableize
    end # method index_resources_path

    def new_resource_path directory, resource
      Directory.join index_resources_path(directory, resource), 'new'
    end # method new_resource_path

    def resource_path resource
      "/#{resource.try(:to_partial_path)}"
    end # method resource_path

    private

    def export_resource_path resource, pretty: false
      "#{Directory.join resource_path(resource), 'export'}#{pretty ? '?pretty=true' : ''}"
    end # method export_directory_path

    def preview_resource_path directory, resource
      Directory.join index_resources_path(directory, resource), 'preview'
    end # method preview_resource_path

    def publish_resource_path resource
      Directory.join resource_path(resource), 'publish'
    end # method edit_resource_path

    def unpublish_resource_path resource
      Directory.join resource_path(resource), 'unpublish'
    end # method edit_resource_path
  end # module
end # module
