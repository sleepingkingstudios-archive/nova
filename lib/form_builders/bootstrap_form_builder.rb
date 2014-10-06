# lib/form_builders/bootstrap_form_builder.rb

class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def initialize object_name, object, template, options
    options[:html] ||= {}
    options[:html][:role] ||= 'form'

    super object_name, object, template, options
  end # constructor

  delegate :content_tag, :link_to, :tag, :to => :@template

  def button name = nil, options = nil, html_options = {}, &block
    classes = %w(btn)
    classes << 'btn-default' unless html_options.fetch(:class, '') =~ /btn-/
    html_options[:class] = concat_class html_options.fetch(:class, ''), *classes

    link_to name, options, html_options, &block
  end # method button

  def email_field method, options = {}
    options[:class] = concat_class options.fetch(:class, ''), 'form-control'

    super method, options
  end # method email_field

  def form_group method = nil, options = {}, &block
    options[:class] = concat_class 'form-group', options.fetch(:class, '')

    if !method.blank? && has_errors?
      status  = object.errors.messages.key?(method) ? 'has-error' : 'has-success'
      options[:class] = concat_class options[:class], status, 'has-feedback'
    end # if

    label_options = options.delete(:label)

    content_tag 'div', options do
      if label_options
        @template.concat build_label(method, label_options)
      end # if

      build_input method, &block

      if !method.blank? && has_errors?
        status = object.errors.messages.fetch(method, nil).blank? ? 'ok' : 'remove'
        @template.concat tag('span', :class => "glyphicon glyphicon-#{status} form-control-feedback")
      end # if
    end # content_tag
  end # method form_group

  def help_block text, options = {}
    options[:class] = concat_class options.fetch(:class, ''), 'help-block'

    content_tag 'p', text, options
  end # method help_block

  def label method, text = nil, options = {}, &block
    options[:class] = concat_class options.fetch(:class, ''), 'control-label'

    super method, text, options, &block
  end # method label

  def password_field method, options = {}
    options[:class] = concat_class options.fetch(:class, ''), 'form-control'
    options[:autocomplete] ||= "off"

    super method, options
  end # method password_field

  def select method, choices = nil, options = {}, html_options = {}, &block
    html_options[:class] = concat_class html_options.fetch(:class, ''), 'form-control'

    super method, choices, options, html_options, &block
  end # method select

  def static_field text_or_options = {}, options = {}, &block
    options = block_given? ? text_or_options : options
    options[:class] = concat_class options.fetch(:class, ''), 'form-control-static'

    block_given? ? content_tag(:p, options, &block) : content_tag(:p, text, options)
  end # method static_field

  def submit value = nil, options = {}
    classes = %w(btn)
    classes << 'btn-primary' unless options.fetch(:class, '') =~ /btn-/
    options[:class] = concat_class options.fetch(:class, ''), *classes

    super value, options
  end # method submit

  def text_area method, options = {}
    options[:class] = concat_class options.fetch(:class, ''), 'form-control'

    # Requires the jquery.autosize library, and a JavaScript on-load hook.
    if options.delete :autosize
      options[:data] = options.fetch(:data, {}).merge :'jquery-autosize' => true
    end # if

    super method, options
  end # method text_area

  def text_field method, options = {}
    options[:class] = concat_class options.fetch(:class, ''), 'form-control'

    super method, options
  end # method text_field

  private

  def build_input method, options = {}, &block
    yield if block_given?
  end # method build_input

  def build_label method, options = nil, &block
    case options
    when Hash
      label(method, options.delete(:text), options, &block)
    when String
      label(method, options, &block)
    when true
      label(method, &block)
    end # case
  end # method build_label

  def concat_class base, *classes
    [*base.strip.split(/\s+/), *classes].uniq.join(' ')
  end # method concat_class

  def has_errors?
    !object.errors.blank?
  end # method validated?
end # class
