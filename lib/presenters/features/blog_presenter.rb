# lib/presenters/features/page_presenter.rb

require 'presenters/feature_presenter'

class BlogPresenter < FeaturePresenter
  alias_method :blog, :feature

  def icon_name
    :newspaper_o
  end # method icon_name
end # class
