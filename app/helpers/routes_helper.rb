# app/helpers/routes_helper.rb

module RoutesHelper
  def directory_path *directories
    directories = directories.first if directories.count == 1 && directories.first.is_a?(Array)

    slugs = directories.map do |directory|
      directory.respond_to?(:slug) ? directory.slug : directory
    end # directories

    "/#{slugs.join '/'}"
  end # method directory_path

  def index_directory_path *directories
    "#{directory_path(*directories).sub(/\/\z/,'')}/index"
  end # method directory_path
end # module
