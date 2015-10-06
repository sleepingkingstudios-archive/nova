# lib/exporters/json_exporter.rb

module JsonExporter
  def self.export obj, pretty: false
    if pretty && (obj.is_a?(Array) || obj.is_a?(Hash))
      JSON.pretty_generate obj
    else
      obj.to_json
    end # if-else
  end # class method export

  def self.import json
    ActiveSupport::JSON.decode json.to_s
  rescue JSON::ParserError
    nil
  end # class method import
end # module
