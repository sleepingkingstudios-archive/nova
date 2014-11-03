# lib/presenters/features/page_presenter.rb

require 'presenters/features/directory_feature_presenter'

class PagePresenter < DirectoryFeaturePresenter
  alias_method :page, :feature

  def index?
    slug == 'index'
  end # method index?

  def label
    index? ? directory_presenter.label : super
  end # method label

  private

  def directory_presenter
    DirectoryPresenter.new directory
  end # method directory_presenter

  def icon_name
    :file_o
  end # method icon_name
end # class
