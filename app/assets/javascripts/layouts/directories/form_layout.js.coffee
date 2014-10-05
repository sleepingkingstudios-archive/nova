# app/assets/javascripts/layouts/directories/form_layout.js.coffee

class Appleseed.Layouts.Directories.FormLayout extends Appleseed.Layouts.BaseLayout
  @selectors: {
    title_field: '.title-field'
    slug_field:  '.slug-field'
  }

  initialize: (root, options) ->
    super(root, options)

    console.log 'Directories.FormLayout#initialize()'

    @get('title_field').bind 'keyup', @_titleFieldChanged

  _parameterizeString: (string, separator = '-') =>
    separatorPattern = separator.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&")

    string = string.toLowerCase();
    string = string.replace(/[^a-z0-9\-_]+/g, separator)
    string = string.replace(new RegExp("#{separatorPattern}{2,}", "g"), separator)
    string = string.replace(new RegExp("^#{separatorPattern}"), '')
    string = string.replace(new RegExp("#{separatorPattern}$"), '')

  _titleFieldChanged: (event) =>
    console.log 'Directories.FormLayout#titleFieldChanged()'

    text = @_parameterizeString @get('title_field').val()
    console.log 'Text = "' + text + '"'

    @get('slug_field').attr('placeholder', text)
