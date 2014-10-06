# app/models/features/contents/text_content.rb

class TextContent < Content
  ### Class Methods ###

  class << self
    def content_type_name
      name == 'TextContent' ? 'Plain Text' : super
    end # class method content_type_name
  end # class << self

  ### Attributes ###
  field :text_content, :type => String

  ### Validations ###
  validates :text_content, :presence => true
end # class
