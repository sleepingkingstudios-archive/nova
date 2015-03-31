# app/serializers/serializer.rb

class Serializer < Decorator
  def to_json
    attributes.map.with_object({}) do |attribute, hsh|
      hsh[attribute] = object.respond_to?(attribute) ? object.send(attribute) : object[attribute]
    end # map
  end # method to_json

  private

  def attributes
    []
  end # methoda attributes
end # class
