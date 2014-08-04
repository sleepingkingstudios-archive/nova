# app/models/directory.rb

require 'mongoid/sleeping_king_studios/has_tree'
require 'mongoid/sleeping_king_studios/sluggable'

class Directory
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::HasTree
  include Mongoid::SleepingKingStudios::Sluggable

  class << self
    def find_by_ancestry ancestors
      raise ArgumentError.new "ancestors can't be blank" if ancestors.blank?

      leaf = ancestors.pop
      where(:slug => leaf).each do |directory|
        return directory if directory.ancestors.map(&:slug) == ancestors
      end # each

      raise missing_ancestry_error(leaf, ancestors)
    end # class method find_by_ancestry

    private

    def missing_ancestry_error leaf, ancestors
      message = <<-MESSAGE

Problem:
  Document not found for class Directory with slug #{leaf.inspect} and ancestors #{ancestors}.
Summary:
  When calling Directory.find_by_ancestry with an array of slugs, the array
  must match a valid chain of directories terminating at a root directory.
Resolution:
  Ensure that the requested directories exist in the database by inspecting
  Directory.roots to find the root directory in the chain, and then the
  directory.children relation to find each requested child.
MESSAGE
      StandardError.new message.rstrip
    end # class method missing_ancestry_error
  end # class << self

  ### Attributes ###
  field :title, :type => String, :default => ''

  ### Concerns ###
  has_tree
  slugify :title, :lockable => true

  ### Validations ###
  validates :title, :presence => true
  validates :slug,  :uniqueness => { :scope => :parent_id }

  def ancestors
    parent ? parent.ancestors.push(parent) : []
  end # method ancestors
end # class
