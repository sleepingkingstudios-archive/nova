# lib/form_builders/bootstrap_horizontal_form_builder.rb

require 'form_builders/bootstrap_form_builder'

class BootstrapHorizontalFormBuilder < BootstrapFormBuilder
  def initialize object_name, object, template, options
    options[:html] ||= {}
    options[:html][:class] = concat_class options.fetch(:html, {}).fetch(:class, ''), 'form-horizontal'

    super object_name, object, template, options
  end # constructor

  def form_group method = nil, options = {}, &block
    options[:label] = true unless options.key?(:label)

    super method, options, &block
  end # method form_group

  private

  def build_input method, options = {}, &block
    @template.concat content_tag('div', :class => 'col-sm-10') {
      yield if block_given?
    } # content_tag
  end # method build_input

  def build_label method, options = nil, &block
    return content_tag 'div', '&nbsp;'.html_safe, :class => 'col-sm-2' if method.blank?

    case options
    when Hash
      hsh = options
    when String
      hsh = { :text => options }
    when true
      hsh = {}
    end # case

    hsh[:class] = concat_class hsh.fetch(:class, ''), 'col-sm-2'

    super method, hsh, &block
  end # method build_label
end # class
