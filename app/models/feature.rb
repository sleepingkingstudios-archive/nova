# app/models/feature.rb

require 'mongoid/sleeping_king_studios/sluggable'

require 'validators/unique_within_siblings_validator'

class Feature
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::Sluggable

  ### Class Methods ###

  class << self
    def reserved_slugs
      Directory.reserved_slugs
    end # class method reserved_slugs
  end # class << self

  scope :roots, ->() { where(:directory_id => nil) }

  ### Attributes ###
  field :title, :type => String

  ### Concerns ###
  slugify :title, :lockable => true

  ### Relations ###
  belongs_to :directory

  ### Validations ###
  validates :title, :presence => true
  validates :slug,  :exclusion => { :in => ->(document) { document.class.reserved_slugs } }, :unique_within_siblings => true

  ### Instance Methods ###

  def to_partial_path
    directory ?
      Directory.join(*[directory.to_partial_path, slug].reject { |slug| slug.blank? }) :
      slug
  end # method to_partial_path
end # model
