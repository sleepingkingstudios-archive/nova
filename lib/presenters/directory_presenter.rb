# lib/presenters/directory_presenter.rb

require 'presenters/presenter'

class DirectoryPresenter < Presenter
  alias_method :directory, :object

  def title
    directory.blank? ? 'Root Directory' : directory.title
  end # method title
end # class
