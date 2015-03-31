# app/decorators/decorator.rb

class Decorator
  def initialize object
    @object       = object
    @object_class = object.class
  end # constructor

  attr_reader :object, :object_class
end # class
