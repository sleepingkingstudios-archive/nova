# app/helpers/routes_helper.rb

module RoutesHelper
  def directories_path *directories
    directories = directories.first if directories.count == 1 && directories.first.is_a?(Array)

    slugs = directories.map do |directory|
      directory.respond_to?(:slug) ? directory.slug : directory
    end # directories

    "/#{slugs.join '/'}"
  end # method directories_path

  def directory_path directory
    return '/' if directory.blank?

    slugs = directory.ancestors.map(&:slug).push(directory.slug)

    "/#{slugs.join '/'}"
  end # method directory_path

  def index_directory_path directory
    return '/index' if directory.blank?

    "#{directory_path(directory)}/index"
  end # method directory_path
end # module
