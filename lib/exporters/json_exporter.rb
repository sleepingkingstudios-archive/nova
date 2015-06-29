# lib/exporters/json_exporter.rb

module JsonExporter
  def self.export hsh
    hsh.to_json
  end # class method export

  def self.import json
    ActiveSupport::JSON.decode json.to_s
  rescue JSON::ParserError
    nil
  end # class method import
end # module
