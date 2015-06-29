# lib/exporters/yaml_exporter.rb

module YamlExporter
  def self.export hsh
    YAML.dump hsh
  end # class method export

  def self.import yaml
    result = YAML.load yaml.to_s
    result ? result : nil
  rescue Psych::SyntaxError
    nil
  end # class method import
end # module
