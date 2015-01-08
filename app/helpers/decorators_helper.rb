# app/helpers/decorators_helper.rb

Dir[Rails.root.join 'lib', 'presenters', '**', '*presenter.rb'].each do |file|
  require file
end # each

module DecoratorsHelper
  def decorate object, decorator_type, options = {}
    decorator_name = decorator_type.is_a?(Class) ? decorator_type.name : decorator_type.to_s.classify

    object_klass = case object
    when Class
      object
    when Array
      object.first.class
    when String
      object = object.classify.constantize
    when Symbol
      object = object.to_s.classify.constantize
    else
      object.class
    end # case

    while object_klass != Object && object_klass != nil
      begin
        object_name = object_klass.name
        object_name = object_name.pluralize if options.fetch(:plural, false)

        decorator_class = "#{object_name}#{decorator_name}".constantize

        return decorator_class.new(object)
      rescue NameError => exception
        object_klass = object_klass.superclass
      end # begin-rescue
    end # while

    options.fetch(:default, decorator_name).to_s.constantize.new(object)
  end # method decorate

  def present object
    decorate object, :presenter
  end # method present
end # module
