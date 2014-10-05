# app/assets/javascripts/layouts/concerns/slug_field_automation.js.coffee

Appleseed.Layouts.Concerns.SlugFieldAutomation = {
  included: ->
    @addInitializer ->
      self = @
      @get('title_field').bind 'keyup', @_titleFieldChangeHandler()

  _titleFieldChangeHandler: ->
    layout = @
    => layout.get('slug_field').attr('placeholder', layout._parameterizeString layout.get('title_field').val())
}

Appleseed.extend Appleseed.Layouts.Concerns.SlugFieldAutomation, Appleseed.Helpers.StringHelpers
