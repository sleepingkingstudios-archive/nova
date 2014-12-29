# lib/presenters/directory_presenter.rb

require 'presenters/presenter'

class DirectoryPresenter < Presenter
  include IconsHelper
  include RoutesHelper

  alias_method :directory, :object

  def children
    directory.blank? ? Directory.roots : directory.children
  end # method children

  def features
    directory.blank? ? DirectoryFeature.roots : directory.features
  end # method features

  def label
    return 'Root Directory' if directory.blank?

    directory.title_changed? && !directory.title_was.blank? ? directory.title_was : directory.title
  end # method label

  def parent
    directory.blank? ? nil : directory.parent
  end # method parent

  def parent_link options = {}
    return empty_value if directory.blank?

    path = case options[:action].to_s
    when 'dashboard'
      dashboard_directory_path(parent)
    when 'index'
      index_directories_path(parent)
    else
      directory_path(parent)
    end # when

    content = parent ? parent.title : 'Root Directory'

    content = "#{options[:prefix]} #{content}" if options[:prefix]

    content = "#{icon options[:icon], :width => :fixed} #{content}".html_safe if options[:icon]

    link_to(content, path)
  end # method parent_link

  def root?
    directory.try(:parent).blank?
  end # method root?

  def slug
    directory.blank? ? empty_value : directory.slug
  end # method slug

  def title
    directory.blank? ? empty_value : directory.title
  end # method title
end # class
