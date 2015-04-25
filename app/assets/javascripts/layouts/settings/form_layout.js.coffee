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

    @$form = root.el
    @$form.on 'submit', @submitForm

  @$form = null

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

    console.log('FormLayout.submitForm()')

    action = @$form.attr('action')
    data   = @_formData()

    console.log(@$form)
    console.log(action)
    console.log(data)

    @hideErrors()

    request = $.post action, data
    request.done @submitFormSuccess
    request.fail @submitFormFailure

  _formData: () =>
    data = @$form.serialize()

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
