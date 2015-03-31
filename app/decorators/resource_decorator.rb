# app/decorators/resource_decorator.rb

class ResourceDecorator < Decorator
  include DecorateClassOrInstance

  alias_method :resource, :object
  alias_method :resource_class, :object_class

  def resource_key
    resource_class.to_s.underscore
  end # method resource_key

  def resource_name
    resource_class.to_s.tableize
  end # method resource_name
end # class
