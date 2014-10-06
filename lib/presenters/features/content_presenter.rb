# lib/presenters/features/content_presenter.rb

require 'presenters/presenter'

class ContentPresenter < Presenter
  alias_method :content, :object

  class << self
    def select_options_for_content_type
      Content.content_types.map do |_, value|
        [value.content_type_name, value.to_s.underscore.pluralize]
      end.sort { |(u, _), (v, _)| u <=> v }
    end # class method select_options_for_content_type
  end # class << self

  def form_partial_path
    return 'admin/features/contents/fields' if type.blank? || type == 'content'

    "admin/features/contents/#{type.pluralize}/fields"
  end # method form_partial_path

  def render_content template
    # No-op for default content; override this in subclasses.
  end # method render_content

  def type
    case
    when content.is_a?(Class)
      content.name.underscore
    else
      content.try(:_type)
    end.underscore
  end # type
end # class
