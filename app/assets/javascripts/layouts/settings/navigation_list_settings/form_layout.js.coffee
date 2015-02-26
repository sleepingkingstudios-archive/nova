- # app/assets/javascripts/layouts/settings/navigation_list_settings/form_layout.js.coffee

class Appleseed.Layouts.Settings.NavigationListSettings.FormLayout extends Appleseed.Layouts.Settings.FormLayout
  @selectors: {
    createItemButton: '.create-item-button'
    list: {
      sel: '.list-items'
      items: '> div.row'
      template: '.item-template div.row'
    }
  }

  initialize: (root, options) ->
    super(root, options)

    console.log 'NavigationListSettings.FormLayout#initialize()'

    @get('createItemButton').bind 'click', @createItem

  createItem: (event) =>
    event.preventDefault()

    console.log 'NavigationListSettings.FormLayout#createItem()'

    $item = @get('list.template').clone()
    @get('list.items').last().after($item)

    @_updateItemOrderingKeys()

  _formData: () =>
    $templateControls = @get('list.template').find('label, input[type="text"]')
    $templateControls.prop('disabled', true)

    data = super

    $templateControls.prop('disabled', false)

    data

  _updateItemOrderingKeys: () =>
    console.log 'NavigationListSettings.FormLayout#_updateItemOrderingKeys()'

    for item, index in @get('list.items')
      $item = $(item)

      for label in $item.find('label')
        $label = $(label)

        name = $label.attr('for')
        name = name.replace /value_-?\d+_/, "value_#{index}_"
        $label.attr('for', name)

      for control in $item.find('input[type="text"]')
        $control = $(control)

        name = $control.attr('name')
        name = name.replace /\[value\]\[-?\d+\]/, "[value][#{index}]"
        $control.attr('name', name)

        id = $control.attr('id')
        id = id.replace /value_-?\d+_/, "value_#{index}_"
        $control.attr('id', id)
