# app/models/features/content.rb

class Content
  include Mongoid::Document

  ### Class Methods ###

  class << self
    def content_type name, options = {}
      type_key   = name.to_s.singularize.sub(/Content\z/i, '').underscore.intern
      class_name = options.key?(:class) ? options[:class].to_s : "#{type_key.to_s.camelize}Content"
      type_class = class_name.constantize

      content_types[type_key] = type_class
    end # method content_type

    def content_types
      @content_types ||= {}
    end # method content_types
  end # class << self

  ### Relations ###
  embedded_in :container, :polymorphic => true

  ### Validation ###
  validates :container, :presence => true
end # class
