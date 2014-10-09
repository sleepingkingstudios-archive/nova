# lib/routers/directory_router.rb

require 'routers/router'

class DirectoryRouter < Router
  include DecoratorsHelper

  alias_method :directory, :object

  def route_to search, found, missing
    super || route_to_feature    
  end # method route_to

  private

  def features
    directory.try(:features) or Feature.roots
  end # method features

  def route_to_feature
    return unless feature = features.where(:slug => missing.first).first

    @missing = missing[1..-1]
    @found   = found + [feature]

    return feature if missing.empty?

    decorator = decorate feature, :Router
    decorator.route_to(search, found, missing)
  end # method route_to_feature
end # class
