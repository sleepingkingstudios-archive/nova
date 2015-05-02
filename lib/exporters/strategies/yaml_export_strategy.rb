# lib/exporters/strategies/yaml_export_strategy.rb

module YamlExportStrategy
  def self.deserialize string
    result = YAML.load string.to_s
    result ? result : nil
  rescue Psych::SyntaxError
    nil
  end # class method deserialize

  def self.serialize object
    YAML.dump object
  end # class method serialize
end # module
