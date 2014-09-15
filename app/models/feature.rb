# app/models/feature.rb

require 'mongoid/sleeping_king_studios/sluggable'

require 'validators/unique_within_siblings_validator'

class Feature
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::Sluggable

  ### Attributes ###
  field :title, :type => String

  ### Concerns ###
  slugify :title, :lockable => true

  ### Relations ###
  belongs_to :directory

  ### Validations ###
  validates :title, :presence => true
  validates :slug,  :unique_within_siblings => true
end # model
