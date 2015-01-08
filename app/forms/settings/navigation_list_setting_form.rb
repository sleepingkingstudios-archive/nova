# app/forms/settings/navigation_list_setting_form.rb

class NavigationListSettingForm < SettingForm
  def update params
    super

    if (value = params.fetch(resource.key, {}).fetch('value', nil)).blank?
      resource.list ? resource.list.destroy : nil
    else
      resource.list ||= resource.build_list
      resource.list.value = value
    end # if
  end # method update
end # class
