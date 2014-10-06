# app/models/features/content.rb

class Content
  include Mongoid::Document

  ### Class Methods ###

  class << self
    def content_types
      (@content_types ||= {}).dup
    end # class method content_types

    def content_type_name
      (type_name = name.sub(/Content\z/, '')).blank? ? 'Content' : type_name
    end # class method content_type_name

    private

    def content_type subclass
      type_key = subclass.to_s.singularize.sub(/Content\z/i, '').underscore.intern

      (@content_types ||= {})[type_key] = subclass
    end # class method content_type

    def inherited subclass
      Content.send :content_type, subclass
    end # class method inherited
  end # class << self

  ### Relations ###
  embedded_in :container, :polymorphic => true

  ### Validation ###
  validates :container, :presence => true

  ### Instance Methods ###
  def _type
    self[:_type] || self.class.name
  end # method type
end # class
