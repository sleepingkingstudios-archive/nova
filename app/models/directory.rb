# app/models/directory.rb

require 'mongoid/sleeping_king_studios/sluggable'

class Directory
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::Sluggable

  ### Attributes ###
  field :title, :type => String, :default => ''

  ### Concerns ###
  slugify :title, :lockable => true

  ### Validations ###
  validates :title, :presence => true
end # class
