# app/assets/javascripts/layouts/settings/form_layout.js.coffee

class Appleseed.Layouts.Settings.FormLayout extends Appleseed.Layouts.BaseLayout
  @selectors: {
    errors: {
      sel: '.errors',
      messages: 'ul'
    }
  }

  initialize: (root, options) ->
    super(root, options)

    $form = root.el
    $form.bind 'submit', @submitForm

  clearErrors: () =>
    @get('errors.messages').empty()

  hideErrors: () =>
    @get('errors').hide()

  showErrors: (messages) =>
    @clearErrors()

    if messages? && messages.length?
      $messages = @get('errors.messages')

      for message in messages
        $messages.append $('<li>').text(message)

    @get('errors').show()

  ### Network Requests ###

  submitForm: (event) =>
    event.preventDefault()

    $form  = $(event.target)
    action = $form.attr('action')
    data   = $form.serialize()

    @hideErrors()

    request = $.post action, data
    request.done @submitFormSuccess
    request.fail @submitFormFailure

  ### Event Handlers ###

  submitFormFailure: (xhr, status, error) =>
    console.log 'Settings.FormLayout#submitFormFailure(): ' + error
    console.log xhr.responseText

    response = JSON.parse(xhr.responseText)
    setting  = response.setting
    errors   = setting.errors

    @showErrors(errors)

  submitFormSuccess: (data, status, xhr) =>
    window.location.reload()
