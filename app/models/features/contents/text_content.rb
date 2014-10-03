# app/models/features/contents/text_content.rb

class TextContent < Content
  field :text_content, :type => String

  validates :text_content, :presence => true
end # class
