# app/serializers/settings/setting_serializer.rb

class SettingSerializer < ResourceSerializer
  private

  def attributes
    %w(options value)
  end # method attributes
end # class
