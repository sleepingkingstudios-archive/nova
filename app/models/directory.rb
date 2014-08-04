# app/models/directory.rb

require 'mongoid/sleeping_king_studios/has_tree'
require 'mongoid/sleeping_king_studios/sluggable'

class Directory
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::HasTree
  include Mongoid::SleepingKingStudios::Sluggable

  ### Class Methods ###

  class << self
    def find_by_ancestry segments
      raise ArgumentError.new "path can't be blank" if segments.blank?

      directories = []
      segments.each.with_index do |segment, index|
        directory = where(:parent_id => directories.last.try(:id), :slug => segment).first

        if directory.nil?
          raise Directory::NotFoundError.new segments, directories, segments[index..-1]
        else
          directories << directory
        end # if-else
      end # each

      return directories
    end # class method find_by_ancestry
  end # class << self

  ### Attributes ###
  field :title, :type => String, :default => ''

  ### Concerns ###
  has_tree
  slugify :title, :lockable => true

  ### Validations ###
  validates :title, :presence => true
  validates :slug,  :uniqueness => { :scope => :parent_id }

  ### Instance Methods ###

  def ancestors
    parent ? parent.ancestors.push(parent) : []
  end # method ancestors

  class NotFoundError < StandardError
    def initialize search, found, missing
      @search  = search
      @found   = found
      @missing = missing

      super(message)
    end # constructor

    attr_reader :found, :missing, :search

    def message
      "Problem:\n"\
        "  Document(s) not found for class Directory with path "\
        "#{search.join('/').inspect}.\n"\
        "Summary:\n"\
        "  When calling Directory.find_by_ancestry with an array of slugs, "\
        "the array must match a valid chain of directories terminating at a "\
        "root directory. The search was for the slug(s): "\
        "#{search.join(', ')} ... (#{search.count} total) and the "\
        "following slug(s) were not found: #{missing.join(', ')}.\n"\
        "Resolution:\n"\
        "  Ensure that the requested directories exist in the database by "\
        "inspecting Directory.roots to find the root directory in the "\
        "chain, and then the directory.children relation to find each "\
        "requested child."
    end # method message
  end # class
end # class
