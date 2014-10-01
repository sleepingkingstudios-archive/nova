# lib/errors/resource_not_found_error.rb

module Appleseed
  class ResourceNotFoundError < StandardError
    def initialize search, found, missing
      @search  = search
      @found   = found
      @missing = missing
    end # constructor

    attr_reader :search, :found, :missing

    def message
      "Problem:\n  #{problem}\n"\
      "Summary:\n  #{summary}\n"\
      "Resolution:\n  #{resolution}"
    end # method message

    private

    def problem
      "Resource not found with path #{search.join('/').inspect}."
    end # method problem

    def resolution
      "Ensure that the resource exists in the database by navigating to the "\
        "containing directory at #{found.join('/')} and inspecting the "\
        "#features and #children relations."
    end # method resolution

    def summary
      "The path array must match a valid chain of directories originating at "\
        "a root directory, with the final path segment representing the "\
        "resource being searched for. The search was for the slug(s): "\
        "#{search.join(', ')} ... (#{search.count} total) and the resource "\
        "with slug \"#{missing}\" was not found."
    end # method summary
  end # class
end # module
