# lib/routers/directory_router.rb

require 'routers/router'

class DirectoryRouter < Router
  alias_method :directory, :object

  def route_to search, found, missing
    super || route_to_feature    
  end # method route_to

  private

  def route_to_feature
    return unless feature = directory.features.where(:slug => missing.first).first

    @missing = missing[1..-1]
    @found   = found + [feature]

    return feature if missing.empty?
  end # method route_to_feature
end # class
