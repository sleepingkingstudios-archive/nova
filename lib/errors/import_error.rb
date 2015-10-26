# lib/errors/import_error.rb

module Appleseed
  class ImportError < StandardError
    def initialize raw, format
      @raw    = raw
      @format = format
    end # method initialize

    attr_reader :raw, :format

    def message
      "unable to import object from #{format} string"
    end # method message
  end # class
end # module
