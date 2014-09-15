# app/models/features/pages/page_content.rb

class PageContent
  include Mongoid::Document

  ### Relations ###
  embedded_in :page, :inverse_of => :content

  ### Validation ###
  validates :page, :presence => true
end # class
