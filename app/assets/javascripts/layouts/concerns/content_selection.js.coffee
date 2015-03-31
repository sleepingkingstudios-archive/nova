# app/assets/javascripts/layouts/concerns/content_selection.js.coffee

Appleseed.Layouts.Concerns.ContentSelection = {
  included: ->
    @addInitializer ->
      console.log 'ContentSelection#initialize()'
      @get('content.selector').bind 'change', @_contentSelectorChangedHandler()

  ### Private Methods ###

  _clearContent: ->
    @get('content.area').html('')

  _setContent: (htmlContent) ->
    @get('content.area').html(htmlContent)

  _deserializeContentData: (data) ->
    $(input = $("##{id}"))?.val(value) for id, value of data

  _serializeContentData: ->
    data = {}
    for input in @get('content.inputs')
      $input = $(input)
      continue if !$input.attr('id') || $input.attr('id').match(/content_+type/)

      data[$input.attr('id')] = $input.val()

    @_serializedContentData = data

  _hideErrorNotice: ->
    @get('content.error').addClass('hidden')

  _hideLoadingNotice: ->
    @get('content.loading').addClass('hidden')

  _showErrorNotice: ->
    @get('content.error').removeClass('hidden')

  _showLoadingNotice: ->
    @get('content.loading').removeClass('hidden')

  ### Network Requests ###

  _requestContentFields: (contentType) ->
    fieldsUrl = "/admin/contents/#{contentType}/fields?resource_type=#{@_resourceType}"

    request = $.get(fieldsUrl)
    request.done @_requestContentFieldsSuccessHandler()
    request.fail @_requestContentFieldsFailureHandler()

  ### Event Handlers ###

  _contentSelectorChangedHandler: ->
    layout = @
    (event) =>
      contentType = layout.get('content.selector').val()

      layout._serializeContentData()
      layout._clearContent()
      layout._hideErrorNotice()
      layout._showLoadingNotice()
      layout._requestContentFields(contentType)

  _requestContentFieldsSuccessHandler: ->
    layout = @
    (htmlContent, status, request) =>
      layout._hideLoadingNotice()
      layout._setContent(htmlContent)
      layout._deserializeContentData(@_serializedContentData) if @_serializedContentData?

  _requestContentFieldsFailureHandler: ->
    (request, status, message) =>
      console.log 'Pages.FormLayout#requestContentFieldsFailure()'
      console.log arguments

      @_hideLoadingNotice()
      @_showErrorNotice()
}
