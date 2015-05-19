# app/models/feature.rb

require 'mongoid/sleeping_king_studios/sluggable'

class Feature
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::SleepingKingStudios::Sluggable

  ### Class Methods ###

  class << self
    def default_content_type
      :text
    end # method default_content_type

    def reserved_slugs
      Directory.reserved_slugs
    end # class method reserved_slugs
  end # class << self

  ### Attributes ###
  field :title, :type => String

  ### Concerns ###
  slugify :title, :lockable => true

  ### Validations ###
  validates :title, :presence => true
  validates :slug,  :exclusion => { :in => ->(document) { document.class.reserved_slugs } }
end # model
