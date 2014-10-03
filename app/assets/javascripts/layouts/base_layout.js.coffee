# app/assets/javascripts/layouts/base_layout.js.coffee

class Appleseed.Layouts.BaseLayout extends Backbone.Marionette.LayoutView
  initialize: (options) ->
    super(options)

  get: (name, strict = true) ->
    sel = @selectors()[name]
    throw "Undefined selector \"#{name}\"" unless sel?

    $elements = @$ sel
    if strict && (0 == $elements.length)
      throw "No element found for selector \"#{name}\" ('#{sel}')"

    $elements

  selectors: ->
    return @_selectors if @_selectors?

    inherited = @_getSuperclassProperty 'selectors'
    @_selectors = @_flattenSelectors $.extend(true, {}, inherited ?= {}, @constructor.selectors)

  _flattenSelectors: (hsh, flat = {}, parent = null, scope = null) ->
    sel = hsh.sel ?= ''
    sel = "#{scope} #{sel}" if scope?
    prefix = if 0 < sel.length then "#{sel} " else ''
    for key, value of hsh
      scoped_key = if parent? then "#{parent}.#{key}" else key

      if 'string' == typeof value
        flat[scoped_key] = "#{prefix}#{value}" unless key == 'sel'
      else
        flat[scoped_key] = "#{prefix}#{value.sel}"
        @_flattenSelectors value, flat, scoped_key, sel

    flat

  _getSuperclassProperty: (property) ->
    @constructor.__super__.constructor[property]
