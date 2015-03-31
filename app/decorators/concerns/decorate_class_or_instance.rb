# app/decorators/concerns/decorate_class_or_instance.rb

module DecorateClassOrInstance
  def initialize class_or_instance
    if class_or_instance.is_a?(Class)
      @object       = nil
      @object_class = class_or_instance
    else
      super
    end # if
  end # constructor
end # module
