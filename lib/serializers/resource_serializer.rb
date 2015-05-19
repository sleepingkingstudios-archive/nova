# app/serializers/resource_serializer.rb

require 'serializers/serializer'

class ResourceSerializer < Serializer
  module DSL
    module Attributes
      extend ActiveSupport::Concern

      module ClassMethods
        def attribute attribute_name
          (@permitted_attributes ||= Set.new) << attribute_name.to_s
        end # class method attribute

        def attributes *attribute_names
          attribute_names.each { |attribute_name| attribute attribute_name }
        end # class method attribute

        def permitted_attributes
          @permitted_attributes ||= Set.new

          defined?(superclass.permitted_attributes) ?
            superclass.permitted_attributes.union(@permitted_attributes) :
            @permitted_attributes
        end # class method permitted_attributes
      end # module

      def permitted_attributes
        self.class.permitted_attributes
      end # method permitted_attributes
    end # module

    module Relations
      extend ActiveSupport::Concern

      module ClassMethods
        def embeds_many relation_name
          relates relation_name, :embedded => true,  :plurality => :many
        end # class method embeds_many

        def embeds_one relation_name
          relates relation_name, :embedded => true,  :plurality => :one
        end # class method embeds_one

        def has_many relation_name
          relates relation_name, :embedded => false, :plurality => :many
        end # class method has_many

        def has_one relation_name
          relates relation_name, :embedded => false, :plurality => :one
        end # class method has_one

        def permitted_relations
          @permitted_relations ||= Hash.new

          defined?(superclass.permitted_relations) ?
            superclass.permitted_relations.merge(@permitted_relations) :
            @permitted_relations
        end # class method permitted_relations

        private

        def relates relation_name, embedded:, plurality:
          @permitted_relations ||= Hash.new

          raise ArgumentError.new 'name is already taken' if @permitted_relations[relation_name.to_s]
          raise ArgumentError.new 'plurality must be :one or :many' unless %i(one many).include?(plurality)

          relation = {
            :plurality => plurality,
            :embedded  => !!embedded
          } # end hash
          @permitted_relations[relation_name.to_s] = relation
        end # class method relates
      end # module

      def permitted_relations
        self.class.send :permitted_relations
      end # method permitted_relations
    end # module

  end # module

  include ResourceSerializer::DSL::Attributes
  include ResourceSerializer::DSL::Relations

  class << self
    attr_accessor :resource_class

    protected

    attr_writer :resource_class

    private

    def inherited subclass
      super

      subclass.resource_class = (subclass.name || '').sub(/Serializer/, '').constantize
    rescue NameError => exception
      subclass.resource_class = self.resource_class
    end # method inherited
  end # eigenclass

  def deserialize attributes, type: nil, **options
    super attributes, :type => type || resource_class, **options
  end # method deserialize

  def serialize resource, relations: :embedded, **options
    hsh = super

    hsh.merge! serialize_relations(resource, :relations => relations, **options)

    hsh['errors'] = serialize_errors(resource, **options) if has_errors?(resource)

    hsh['_type'] ||= (resource.try(:_type) || resource.class.name)

    hsh
  end # method serialize

  private

  def has_errors?(resource)
    resource.respond_to?(:errors) && !resource.errors.blank?
  end # method has_errors?

  def resource_class
    self.class.resource_class
  end # method resource_class

  def serializable_relations(relations:, **options)
    if !relations || relations == :none
      relations = []
    elsif relations == :embedded
      relations = permitted_relations.select { |_, hsh| hsh[:embedded] == true }
    else
      relations = permitted_relations
    end # if-elsif-else
  end # method serializable_relations

  def serialize_errors(resource, **options)
    resource.errors.full_messages
  end # method serialize_errors

  def serialize_relation relation, relation_name, relation_params, relations:
    if relation_params[:plurality] == :one
      return nil if relation.nil?

      exporter = decorator_class(relation, 'Exporter')
      exporter.serialize(relation, :relations => relations)
    else
      return [] if relation.empty?

      relation.map do |obj|
        exporter = decorator_class(obj, 'Exporter')
        exporter.serialize(obj, :relations => relations)
      end # map
    end # if-else
  end # method serialize_relation

  def serialize_relations(resource, relations:, **options)
    serializable_relations(:relations => relations, **options).each.with_object({}) do |(relation_name, relation_params), hsh|
      relation = resource.send(relation_name)

      hsh[relation_name.to_s] = serialize_relation(relation, relation_name, relation_params, :relations => relations)
    end # each
  end # method serialize_relations
end # class
