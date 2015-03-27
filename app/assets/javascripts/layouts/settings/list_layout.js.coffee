# app/assets/javascripts/layouts/settings/list_layout.js.coffee

class Appleseed.Layouts.Settings.ListLayout extends Appleseed.Layouts.BaseLayout
  @selectors: {
    edit_button: '.edit-setting-link'
    modal:
      sel:    'body #edit-setting-modal'
      action: '.confirm-edit-button'
      dialog: '.modal-dialog'
      body:   '.modal-body'
      title:  '.edit-setting-title'
  }

  initialize: (root, options) ->
    super(root, options)

    @get('edit_button').on 'click', @editButtonClicked

    @get('modal').on 'hidden.bs.modal', @_resetModal

  $editForm: null

  $layoutView: null

  _configureModal: ($setting) =>
    $form      = $setting.children('.form-container').children('form')
    @$editForm = $form.clone()

    @get('modal.body').html(@$editForm)

    options = $setting.data()

    @get('modal.dialog').addClass(options.modalClass) if options.modalClass
    @get('modal.title').text('Edit ' + options.label || 'Setting')

    layoutName   = options.layoutName || 'Settings.FormLayout'
    layoutClass  = Appleseed.resolveNamespace("Layouts.#{layoutName}")
    @$layoutView = new layoutClass { el: @$editForm }

    @get('modal.action').on('click', @updateButtonClicked)

  _openModal: (event) =>
    @get('modal').modal(
      backdrop: 'static'
    )

  _resetModal: (event) =>
    @$layoutView.destroy() if @$layoutView?
    @$layoutView = null

    @$editForm = null

    @get('modal.dialog').removeClass('modal-lg modal-sm')
    @get('modal.body').empty()

    @get('modal.action').off('click')

  ### Event Handlers ###

  editButtonClicked: (event) =>
    event.preventDefault()

    @_configureModal($(event.target).closest('.setting'))

    @_openModal()

  updateButtonClicked: (event) =>
    event.preventDefault()

    @$editForm.submit()
