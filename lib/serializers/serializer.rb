# lib/serializers/serializer.rb

class Serializer
  class << self
    def default_options
      {}
    end # class method default_options

    %w(deserialize serialize).each do |method_name|
      define_method(method_name) do |*args, **kwargs, &block|
        new.send(method_name, *args, **kwargs, &block)
      end # define method
    end # each
  end # eigenclass

  def initialize **default_options
    @default_options = self.class.default_options.merge(default_options)
  end # constructor

  attr_accessor :default_options

  def deserialize attributes, type:, **options
    attributes = attributes.with_indifferent_access

    @resource = build_resource(:type => type, **options)

    permitted_attributes.each do |attribute_name|
      deserialize_attribute resource, attribute_name, attributes[attribute_name]
    end # each with object

    resource
  end # method deserialize

  def serialize resource, **options
    @resource = resource

    permitted_attributes.each.with_object({}) do |attribute_name, hsh|
      hsh[attribute_name] = serialize_attribute(resource, attribute_name)
    end # each with object
  end # method serialize

  def permitted_attributes
    []
  end # method permitted_attributes

  private

  attr_reader :resource

  def build_resource type:, **options
    case type
    when Class
      type.new
    else
      type.to_s.constantize.new
    end # case
  end # method build_resource

  def deserialize_attribute resource, attribute_name, attribute_value
    writer_name = attribute_name.to_s.sub(/=?\z/, '=')

    if self.respond_to?(writer_name)
      self.send(writer_name, attribute_value)
    elsif resource.respond_to?(writer_name)
      resource.send(writer_name, attribute_value)
    else
      resource[attribute_name] = attribute_value
    end # if-elsif-else
  end # method deserialize_attribute

  def serialize_attribute resource, attribute_name
    if self.respond_to?(attribute_name)
      self.send(attribute_name)
    elsif resource.respond_to?(attribute_name)
      resource.send(attribute_name)
    else
      resource[attribute_name]
    end # if-elsif-else
  end # method serialize_attribute
end # class
