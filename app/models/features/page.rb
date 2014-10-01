# app/models/features/page.rb

class Page < Feature
  Directory.feature :page

  ### Class Methods ###

  class << self
    def reserved_slugs
      Feature.reserved_slugs.reject { |slug| slug == 'index' }
    end # class method reserved_slugs
  end # class << self

  ### Relations ###
  embeds_one :content, :as => :container

  ### Validations ###
  validates :content, :presence => true
end # model
