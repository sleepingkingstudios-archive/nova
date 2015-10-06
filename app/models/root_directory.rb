# app/models/root_directory.rb

class RootDirectory
  class << self
    private :new

    def instance
      @instance ||= new
    end # class method instance

    def name
      'Directory'
    end # class method name
  end # eigenclass

  def blank?
    true
  end # method blank

  def [](_)
    nil
  end # method []

  def attributes
    {}
  end # method attributes

  def bson_type
    nil.bson_type
  end # bson_type

  def children
    Directory.roots
  end # method children
  alias_method :directories, :children

  def features
    DirectoryFeature.roots
  end # method features

  def parent
    nil
  end # method parent

  def to_bson *args
    nil.to_bson(*args)
  end # method to_bson
end # class
