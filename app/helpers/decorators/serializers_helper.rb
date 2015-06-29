# app/helpers/decorators/serializers_helper.rb

Dir[Rails.root.join 'lib', 'serializers', '**', '*serializer.rb'].each do |file|
  require file
end # each

module Decorators
  module SerializersHelper
    include DecoratorsHelper

    def deserialize attributes, type: nil, **options
      type ||= attributes['_type']

      raise ArgumentError.new 'must specify a type' if type.nil?

      serializer_class(type).deserialize(attributes, :type => type, **options)
    end # method deserialize

    def serialize resource, **options
      serializer_class(resource).serialize(resource, **options)
    end # method serialize

    private

    def serializer_class type
      serializer = decorator_class(type, :Serializer)

      if serializer.nil? || !(serializer < Serializer)
        type_string = case type
        when Class
          type.name
        when Array
          type.first.class.name
        when String
          type.classify
        when Symbol
          type.to_s.classify
        else
          type.class.name
        end # case

        raise StandardError.new "undefined serializer for type #{type_string}"
      end # if

      serializer
    end # method serializer_class
  end # module
end # module
