# app/assets/javascripts/layouts/concerns/previewing.js.coffee

Appleseed.Layouts.Concerns.Previewing = {
  included: ->
    @addInitializer ->
      console.log 'Previewing#initialize()'

      @get('previewButton').on 'click', @_previewButtonClickedHandler()

  ### Private Methods ###

  _previewButtonClickedHandler: () ->
    layout = @

    (event) =>
      event.preventDefault()

      $form        = layout.$form
      $button      = $(event.target)
      $methodField = $form.find('input[name="_method"]')

      method = $methodField.val()
      action = $form.attr('action')
      target = $form.attr('target')

      $methodField.val('post')
      $form.attr('action', $button.attr('href'))
      $form.attr('target', '_blank')

      $form.submit();

      $methodField.val(method)
      $form.attr('action', action)
      $form.attr('target', target)
}
