# app/serializers/settings/setting_serializer.rb

require 'serializers/resource_serializer'

class SettingSerializer < ResourceSerializer
  attributes :key, :value, :options
end # class
