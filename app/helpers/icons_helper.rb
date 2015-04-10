# app/helpers/icons_helper.rb

module IconsHelper
  def icon name, options = {}
    icon_name = name.to_s.split(/[-_\s]+/).join('-')

    attributes = %w()

    classes = %w(fa)
    classes << (icon_name.blank? ? 'fa-bug' : "fa-#{icon_name}")

    if klass = options.fetch(:class, false)
      classes.concat klass.strip.split(/\s+/)
    end # if

    classes << 'fa-border' if options.fetch(:border, false)

    classes << 'fa-fw' if options.fetch(:width, false).to_s == 'fixed'

    if flip = options.fetch(:flip, false)
      classes << "fa-flip-#{flip}" if %w(horizontal vertical).include?(flip.to_s.downcase)
    end # if

    if pull = options.fetch(:pull, false)
      classes << "pull-#{pull}" if %w(left right).include?(pull.to_s.downcase)
    end # if

    if rotate = options.fetch(:rotate, false)
      if rotate.is_a?(Integer)
        rotate += 360 if rotate < 0

        classes << "fa-rotate-#{rotate}"
      end # if
    end # if

    if scale = options.fetch(:scale, false)
      if %w(large lg).include?(scale.to_s.downcase)
        classes << 'fa-lg'
      elsif scale.is_a?(Integer) && scale > 1
        classes << "fa-#{scale}x"
      end # if-elsif
    end # if

    classes << 'fa-spin' if options.fetch(:spin, false)

    attributes << %{class="#{classes.join(' ')}"}

    attributes << 'style="color:#F00;"' if icon_name.blank?

    %{<span #{attributes.join(' ')}></span>}.html_safe
  end # method icon

  def icon_name action, resource = nil, default: nil
    scopes = []
    scopes << "features.#{resource.to_s.underscore.pluralize}.icons" unless resource.blank?
    scopes << 'icons'

    scopes.each do |scope|
      begin
        name = I18n.t(action, :scope => scope)

        return name unless name.blank? || name =~ /^translation missing/
      rescue I18n::MissingTranslationData
      end # begin-rescue
    end # each

    default
  end # method icon_name

  private

  def method_missing method, *args, &block
    if method.to_s =~ /_icon$/
      action, *resource = method[0...-5].split '_'

      resource = resource.blank? ? nil : resource.join('_')

      IconsHelper.send :define_method, method do |options = {}|
        icon(icon_name(action.try(:intern), resource.try(:intern)), options)
      end # method

      send method, *args
    else
      super
    end # if-else
  end # method method_missing
end # module
