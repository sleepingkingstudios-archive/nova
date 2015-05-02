# lib/exporters/strategies/json_export_strategy.rb

module JsonExportStrategy
  def self.deserialize string
    ActiveSupport::JSON.decode string.to_s
  rescue JSON::ParserError
    nil
  end # class method deserialize

  def self.serialize hash
    hash.to_json
  end # class method serialize
end # class
