# app/serializers/resource_serializer.rb

class ResourceSerializer < Serializer
  def to_json
    json = super

    json['errors'] = object.errors.full_messages if has_errors?

    json
  end # method to_json

  private

  def has_errors?
    object.respond_to?(:errors) && !object.errors.blank?
  end # method has_errors?
end # class
