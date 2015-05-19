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

      decorator_class(type, :Serializer).deserialize(attributes, :type => type, **options)
    end # method deserialize

    def serialize resource, **options
      decorator_class(resource, :Serializer).serialize(resource, **options)
    end # method serialize
  end # module
end # module
