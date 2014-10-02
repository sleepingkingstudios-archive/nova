# lib/presenters/features/content_presenter.rb

require 'presenters/presenter'

class ContentPresenter < Presenter
  alias_method :content, :object

  def form_partial_path
    return 'admin/features/contents/fields' if type.blank? || type == 'content'

    "admin/features/contents/#{type.pluralize}/fields"
  end # method form_partial_path

  def render_content template

  end # method render_content

  def type
    content.try(:_type).try(:underscore)
  end # type
end # class
