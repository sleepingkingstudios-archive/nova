# app/helpers/routes_helper.rb

module RoutesHelper
  def create_directory_path directory
    index_directories_path directory
  end # method directory_path

  def create_page_path directory
    create_resource_path directory, 'page'
  end # method create_page_path

  def create_resource_path directory, resource
    index_resources_path directory, resource
  end # method create_resource_path

  def dashboard_directory_path directory
    return '/dashboard' if directory.blank?

    Directory.join directory_path(directory), 'dashboard'
  end # method dashboard_directory_path

  def directory_path directory
    resource_path directory
  end # method directory_path

  def edit_directory_path directory
    return '/edit' if directory.blank?

    Directory.join directory_path(directory), 'edit'
  end # method edit_directory_path

  def index_directories_path directory
    return '/directories' if directory.blank?

    Directory.join directory_path(directory), 'directories'
  end # method index_directories_path

  def index_pages_path directory
    index_resources_path directory, 'pages'
  end # method index_pages_path

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

  def new_directory_path directory
    return '/directories/new' if directory.blank?

    Directory.join directory_path(directory), 'directories', 'new'
  end # method new_directory_path

  def new_page_path directory
    new_resource_path directory, 'pages'
  end # method new_page_path

  def new_resource_path directory, resource
    Directory.join index_resources_path(directory, resource), 'new'
  end # method new_resource_path

  def resource_path resource
    "/#{resource.try(:to_partial_path)}"    
  end # method resource_path

  alias_method :page_path, :resource_path
end # module
