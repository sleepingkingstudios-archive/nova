# app/helpers/exporters_helper.rb

require 'errors/import_error'

Dir[Rails.root.join 'lib', 'exporters', '*exporter.rb'].each do |file|
  require file
end # each

module ExportersHelper
  include Decorators::SerializersHelper

  def export obj, format:, **options
    case obj
    when Hash
      serialized = obj
    when Array
      serialized = obj.map { |item| serialize(item, **options) }
    else
      serialized = serialize(obj, **options)
    end # case

    exporter(format).export(serialized)
  end # method export

  def import str, format:, type: nil, **options
    obj = exporter(format).import(str)

    raise Appleseed::ImportError.new str, format if obj.nil?

    case obj
    when Array
      obj.map { |item| deserialize(item, :type => type, **options) }
    else
      deserialize(obj, :type => type, **options)
    end # case
  end # method import

  private

  def exporter format
    "#{format.to_s.camelize}Exporter".constantize
  end # method exporter
end # module
