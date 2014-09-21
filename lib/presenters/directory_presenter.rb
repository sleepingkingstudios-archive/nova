# lib/presenters/directory_presenter.rb

require 'presenters/presenter'

class DirectoryPresenter < Presenter
  alias_method :directory, :object

  def label
    directory.blank? ? 'Root Directory' : directory.title
  end # method label

  def title
    directory.blank? ? empty_value : directory.title
  end # method title
end # class
