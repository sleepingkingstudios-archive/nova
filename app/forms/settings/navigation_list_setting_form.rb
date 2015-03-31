# app/forms/settings/navigation_list_setting_form.rb

class NavigationListSettingForm < SettingForm
  def update params
    # Store the list.
    list_was = resource.list

    update_list(params)

    return true if super

    # Revert the list if validation failed.
    resource.list = list_was
    resource.list.save if resource.list

    false
  end # method update

  private

  def update_list params
    value = params.fetch(resource_key, {}).fetch('value', nil)

    resource.list       = resource.build_list
    resource.list.value = value unless value.blank?
  end # method update_list
end # class
