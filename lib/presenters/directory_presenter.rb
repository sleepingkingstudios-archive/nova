# lib/presenters/directory_presenter.rb

require 'presenters/presenter'

class DirectoryPresenter < Presenter
  alias_method :directory, :object

  def children
    directory.blank? ? Directory.roots : directory.children
  end # method children

  def features
    directory.blank? ? Feature.roots : directory.features
  end # method features

  def label
    return 'Root Directory' if directory.blank?
    
    directory.title_changed? && !directory.title_was.blank? ? directory.title_was : directory.title
  end # method label

  def parent
    directory.blank? ? nil : directory.parent
  end # method parent

  def parent_link action = nil
    return empty_value if directory.blank?

    path = case action.to_s
    when 'dashboard'
      dashboard_directory_path(parent)
    when 'index'
      index_directories_path(parent)
    else
      directory_path(parent)
    end # when

    link_to(parent ? parent.title : 'Root Directory', path)
  end # method parent_link

  def slug
    directory.blank? ? empty_value : directory.slug
  end # method slug

  def title
    directory.blank? ? empty_value : directory.title
  end # method title
end # class
