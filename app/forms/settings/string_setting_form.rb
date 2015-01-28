# app/forms/settings/string_setting_form.rb

class StringSettingForm < SettingForm
  private

  def permitted_params
    %w(value)
  end # method permitted_params
end # class
