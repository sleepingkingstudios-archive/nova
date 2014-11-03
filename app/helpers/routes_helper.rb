# app/helpers/routes_helper.rb

module RoutesHelper
  ### Directory Helpers ###

  def create_directory_path directory
    index_directories_path directory
  end # method directory_path

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

  def new_directory_path directory
    return '/directories/new' if directory.blank?

    Directory.join directory_path(directory), 'directories', 'new'
  end # method new_directory_path

  ### Resource Helpers ###

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

  ### Blog Helpers ###

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

  ### Page Helpers ###

  def create_page_path directory
    create_resource_path directory, 'pages'
  end # method create_page_path

  def edit_page_path resource
    edit_resource_path resource
  end # method edit_page_path

  def index_pages_path directory
    index_resources_path directory, 'pages'
  end # method index_pages_path

  def new_page_path directory
    new_resource_path directory, 'pages'
  end # method new_page_path

  def page_path resource
    resource_path resource
  end # method page_path
end # module
