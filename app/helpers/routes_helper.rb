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

  def export_directory_path directory, pretty: false
    "#{directory.blank? ? '/export' : Directory.join(directory_path(directory), 'export')}#{pretty ? '?pretty=true' : ''}"
  end # method export_directory_path

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

  def export_resource_path resource, pretty: false
    "#{Directory.join resource_path(resource), 'export'}#{pretty ? '?pretty=true' : ''}"
  end # method export_directory_path

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

  def preview_resource_path directory, resource
    Directory.join index_resources_path(directory, resource), 'preview'
  end # method preview_resource_path

  def publish_resource_path resource
    Directory.join resource_path(resource), 'publish'
  end # method edit_resource_path

  def resource_path resource
    "/#{resource.try(:to_partial_path)}"
  end # method resource_path

  def unpublish_resource_path resource
    Directory.join resource_path(resource), 'unpublish'
  end # method edit_resource_path

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

  ### Blog Post Helpers ###

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

  ### Page Helpers ###

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
