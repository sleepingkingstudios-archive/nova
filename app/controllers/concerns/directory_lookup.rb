# app/controllers/concerns/directory_lookup.rb

module DirectoryLookup
  private

  def lookup_directories
    segments = params.fetch(:directories, '').split('/')

    @directories = segments.blank? ? [] : Directory.find_by_ancestry(segments)
  end # method lookup_directories
end # module
