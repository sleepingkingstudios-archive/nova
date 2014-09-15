# app/models/directory.rb

require 'mongoid/sleeping_king_studios/has_tree'
require 'mongoid/sleeping_king_studios/sluggable'

require 'validators/unique_within_siblings_validator'

class Directory
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::HasTree
  include Mongoid::SleepingKingStudios::Sluggable

  ### Class Methods ###

  class << self
    def feature name, options = {}
      model_name  = name.to_s.singularize
      scope_name  = model_name.pluralize
      class_name  = options[:class].to_s || model_name.camelize
      model_class = class_name.constantize

      send :define_method, scope_name do
        features.where(:_type => class_name)
      end # define_method

      send :define_method, "build_#{model_name}" do |attrs|
        model_class.new attrs.merge(:directory_id => self.id)
      end # define_method

      send :define_method, "create_#{model_name}" do |attrs|
        model_class.create attrs.merge(:directory_id => self.id)
      end # define_method

      send :define_method, "create_#{model_name}!" do |attrs|
        model_class.create! attrs.merge(:directory_id => self.id)
      end # define_method
    end # method feature

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

  ### Relations ###
  has_many :features

  ### Validations ###
  validates :title, :presence => true
  validates :slug,  :unique_within_siblings => true

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
