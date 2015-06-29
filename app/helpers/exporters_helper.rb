# app/helpers/exporters_helper.rb

Dir[Rails.root.join 'lib', 'exporters', '*exporter.rb'].each do |file|
  require file
end # each

module ExportersHelper
  include Decorators::SerializersHelper

  def export obj, format:, **options
    hsh = obj.is_a?(Hash) ? obj : serialize(obj, **options)

    exporter(format).export(hsh)
  end # method export

  def import str, format:, type: nil, **options
    hsh = exporter(format).import(str)

    deserialize(hsh, :type => type, **options)
  end # method import

  private

  def exporter format
    "#{format.to_s.camelize}Exporter".constantize
  end # method exporter
end # module
