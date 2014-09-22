# lib/presenters/features/page_presenter.rb

require 'presenters/feature_presenter'

class PagePresenter < FeaturePresenter
  alias_method :page, :feature

  private

  def icon_name
    :file_o
  end # method icon_name
end # class
