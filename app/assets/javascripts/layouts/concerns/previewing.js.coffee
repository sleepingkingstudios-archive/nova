# app/assets/javascripts/layouts/concerns/previewing.js.coffee

Appleseed.Layouts.Concerns.Previewing = {
  included: ->
    @addInitializer ->
      console.log 'Previewing#initialize()'

      console.log @get('previewButton')

      @get('previewButton').on 'click', @_previewButtonClickedHandler()

  ### Private Methods ###

  _previewButtonClickedHandler: () ->
    layout = @

    (event) =>
      event.preventDefault()

      $form = layout.$form

      action = $form.attr('action')
      target = $form.attr('target')

      $form.attr('action', action + '/preview')
      $form.attr('target', '_blank')

      $form.submit();

      $form.attr('action', action)
      $form.attr('target', target)
}
