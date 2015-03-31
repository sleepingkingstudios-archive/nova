# app/helpers/icons_helper.rb

module IconsHelper
  def edit_icon options = {}
    icon :edit, options
  end # method edit_icon

  def icon name, options = {}
    icon_name = name.to_s.split(/[-_\s]+/).join('-')

    classes = %w(fa)
    classes << "fa-#{icon_name}"

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

    %{<span class="#{classes.join(' ')}"></span>}.html_safe
  end # method icon
end # module
