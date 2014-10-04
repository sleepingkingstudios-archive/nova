# lib/presenters/features/content_presenter.rb

require 'presenters/presenter'

class ContentPresenter < Presenter
  alias_method :content, :object

  class << self
    def select_options_for_content_type
      Content.content_types.map do |key, value|
        [key.to_s.split('_').map(&:capitalize).join(' '), value.to_s]
      end # map
    end # class method select_options_for_content_type
  end # class << self

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
