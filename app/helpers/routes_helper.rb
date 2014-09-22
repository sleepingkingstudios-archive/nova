# app/helpers/routes_helper.rb

module RoutesHelper
  def create_directory_path directory
    return '/directories' if directory.blank?

    Directory.join directory_path(directory), 'directories'
  end # method directory_path

  def dashboard_directory_path directory
    return '/dashboard' if directory.blank?

    Directory.join directory_path(directory), 'dashboard'
  end # method directory_path

  def directory_path directory
    "/#{directory.try(:to_partial_path)}"
  end # method directory_path

  def edit_directory_path directory
    return '/edit' if directory.blank?

    Directory.join directory_path(directory), 'edit'
  end # method edit_directory_path

  def index_directory_path directory
    return '/index' if directory.blank?

    Directory.join directory_path(directory), 'index'
  end # method directory_path

  def new_directory_path directory
    return '/directories/new' if directory.blank?

    Directory.join directory_path(directory), 'directories', 'new'
  end # method directory_path
end # module
