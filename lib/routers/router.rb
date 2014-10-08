# lib/routers/router.rb

require 'errors/resources_not_found_error'

class Router
  def initialize object
    @object = object
  end # constructor

  attr_reader :object, :search, :found, :missing

  def route_to search, found, missing
    @search, @found, @missing = search, found, missing

    nil
  end # method route_to

  def route_to! search, found, missing
    route_to(search, found, missing) or raise Appleseed::ResourcesNotFoundError.new(@search, @found, @missing)
  end # method route_to!
end # class
