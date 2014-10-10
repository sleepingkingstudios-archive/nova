# app/controllers/concerns/directory_lookup.rb

require 'errors/resources_not_found_error'

Dir[Rails.root.join 'lib', 'routers', '**', '*.rb'].each do |file|
  require file
end # each

module DirectoryLookup
  include DecoratorsHelper

  private

  def lookup_directories
    segments = params[:directories].try(:split, '/')

    @directories       = segments.blank? ? [] : Directory.find_by_ancestry(segments)
    @current_directory = @directories.last
  rescue Directory::NotFoundError => exception
    # Assign the located directories (if any) to @directories.
    @directories = exception.found

    # Force authentication here, because failed authentication handling
    # requires the full directories path and therefore cannot have run
    # previously.
    authenticate_user! if respond_to?(:authenticate_user!, true)

    raise
  end # method lookup_directories

  def lookup_resource
    # First, see if the entire path refers to a chain of directories. If so,
    # the last directory found will be our resource.
    lookup_directories

    @resource = @directories.last
  rescue Directory::NotFoundError => exception
    # If we're missing more than one path segment, there's at least one
    # directory missing.
    raise if exception.missing.count > 1

    @directories = exception.found

    # Force authentication here, because failed authentication handling
    # requires the full directories path and therefore cannot have run
    # previously.
    authenticate_user! if respond_to?(:authenticate_user!, true)

    router = DirectoryRouter.new @directories.last

    @resource = router.route_to!(exception.search, exception.found, exception.missing)
  end # method lookup_resource
end # module
