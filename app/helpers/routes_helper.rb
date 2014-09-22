# app/helpers/routes_helper.rb

module RoutesHelper
  def create_directory_path directory
    return '/directories' if directory.blank?

    Directory.join directory_path(directory), 'directories'
  end # method directory_path

  def directories_path *directories
    directories = directories.first if directories.count == 1 && directories.first.is_a?(Array)

    slugs = directories.map do |directory|
      directory.respond_to?(:slug) ? directory.slug : directory
    end # directories

    Directory.join '/', *slugs
  end # method directories_path

  def directory_path directory
    return '/' if directory.blank?

    slugs = directory.ancestors.map(&:slug)
    slugs.push(directory.slug) unless directory.slug.blank?

    Directory.join '/', *slugs
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
