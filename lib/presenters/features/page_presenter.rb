# lib/presenters/features/page_presenter.rb

require 'presenters/features/directory_feature_presenter'

class PagePresenter < DirectoryFeaturePresenter
  alias_method :page, :feature

  delegate :published_at, :published?, :to => :page

  def error_messages
    messages = super.tap { |ary| ary.delete 'Content is invalid' }
    messages += page.content.errors.full_messages.uniq unless page.content.blank?
    messages
  end # method error_messages

  def index?
    slug == 'index'
  end # method index?

  def label
    index? ? directory_presenter.label : super
  end # method label

  def published_status
    published? ? 'Yes' : 'No'
  end # method published_status

  private

  def directory_presenter
    DirectoryPresenter.new directory
  end # method directory_presenter

  def icon_name
    :file_o
  end # method icon_name
end # class
