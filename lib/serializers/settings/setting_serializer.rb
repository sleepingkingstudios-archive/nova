# app/serializers/settings/setting_serializer.rb

require 'serializers/resource_serializer'

class SettingSerializer < ResourceSerializer
  attributes :options, :value
end # class
