# lib/services/features_enumerator.rb

module FeaturesEnumerator
  include Enumerable

  extend self

  def each *args, &block
    features.each *args, &block
  end # each

  def feature name, options = {}
    model_name  = name.to_s.singularize
    scope_name  = model_name.pluralize
    class_name  = options.key?(:class) ? options[:class].to_s : model_name.camelize

    # Append to the feature_names collection.
    FeaturesEnumerator.instance_variable_set(:@features,
      FeaturesEnumerator.instance_variable_get(:@features) || {}
    )[scope_name] = class_name

    Directory.feature name, options
  end # method feature

  def features
    FeaturesEnumerator.instance_variable_set(:@features,
      FeaturesEnumerator.instance_variable_get(:@features) || {}
    ).dup
  end # method feature
end # module
