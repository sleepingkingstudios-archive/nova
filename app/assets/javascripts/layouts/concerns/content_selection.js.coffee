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
    # console.log 'Pages.FormLayout#deserializeData()'
    # console.log data

    $(input = $("##{id}"))?.val(value) for id, value of data

  _serializeContentData: ->
    # console.log 'Pages.FormLayout#serializeData()'

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
    # console.log 'Pages.FormLayout#requestContentFields()'

    fieldsUrl = "/admin/contents/#{contentType}/fields?resource_type=#{@_resourceType}"
    # console.log fieldsUrl

    request = $.get(fieldsUrl)
    request.done @_requestContentFieldsSuccessHandler()
    request.fail @_requestContentFieldsFailureHandler()

  ### Event Handlers ###

  _contentSelectorChangedHandler: ->
    layout = @
    (event) =>
      # console.log 'Pages.FormLayout#contentSelectorChanged()'

      contentType = layout.get('content.selector').val()
      # console.log contentType

      layout._serializeContentData()
      layout._clearContent()
      layout._hideErrorNotice()
      layout._showLoadingNotice()
      layout._requestContentFields(contentType)

  _requestContentFieldsSuccessHandler: ->
    layout = @
    (htmlContent, status, request) =>
      # console.log 'Pages.FormLayout#requestContentFieldsSuccess()'
      # console.log arguments

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
