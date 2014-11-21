# lib/presenters/features/page_presenter.rb

require 'presenters/features/directory_feature_presenter'

class BlogPresenter < DirectoryFeaturePresenter
  alias_method :blog, :feature

  def icon_name
    :newspaper_o
  end # method icon_name
end # class
