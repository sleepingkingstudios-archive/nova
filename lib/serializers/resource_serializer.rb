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
  include DecoratorsHelper

  class << self
    attr_accessor :resource_class

    def persist_resource *args, **kwargs, &block
      new.send(:persist_resource, *args, **kwargs, &block)
    end # class method persist_resource

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

  def deserialize attributes, persist: false, type: nil, **options
    resource = super attributes, :type => type || resource_class, **options

    deserialize_relations(resource, attributes.with_indifferent_access, :persist => persist, **options)

    resource
  end # method deserialize

  def serialize resource, relations: :embedded, **options
    hsh = super

    hsh.merge! serialize_relations(resource, :relations => relations, **options)

    hsh['errors'] = serialize_errors(resource, **options) if has_errors?(resource)

    hsh['_type'] ||= (resource.try(:_type) || resource.class.name)

    hsh
  end # method serialize

  protected

  def persist_resource resource, **options
    resource.save!
  end # method persist_resource

  private

  def deserialize_relation resource, relation_name, relation_params, relation_attrs, persist: false, **options
    return if relation_attrs.blank?

    if relation_params[:plurality] == :one
      relation_attrs = relation_attrs.stringify_keys
      serializer     = decorator_class(relation_attrs.fetch('_type'), 'Serializer')
      relation       = serializer.deserialize(relation_attrs, **options)

      resource.send :"#{relation_name}=", relation

      serializer.persist_resource(relation) if persist
    else
      collection = resource.send(relation_name)

      relation_attrs.each do |relation_attrs|
        serializer = decorator_class(relation_attrs.stringify_keys.fetch('_type'), 'Serializer')
        relation   = serializer.deserialize(relation_attrs, **options)

        collection << relation

        serializer.persist_resource(relation) if persist
      end # each
    end # if-else
  end # method deserialize_relation

  def deserialize_relations resource, attributes, persist: false, **options
    embedded_relations = permitted_relations.select { |_, relation_params| relation_params[:embedded] == true }
    embedded_relations.each do |relation_name, relation_params|
      deserialize_relation resource, relation_name, relation_params, attributes[relation_name], :persist => false, **options
    end # each

    persist_resource(resource) if persist

    referenced_relations = permitted_relations.reject { |_, relation_params| relation_params[:embedded] == true }
    referenced_relations.each do |relation_name, relation_params|
      deserialize_relation resource, relation_name, relation_params, attributes[relation_name], :persist => persist, **options
    end # each
  end # method deserialize_relations

  def has_errors? resource
    resource.respond_to?(:errors) && !resource.errors.blank?
  end # method has_errors?

  def resource_class
    self.class.resource_class
  end # method resource_class

  def serializable_relations relations:, **options
    if !relations || relations == :none
      relations = []
    elsif relations == :embedded
      relations = permitted_relations.select { |_, hsh| hsh[:embedded] == true }
    else
      relations = permitted_relations
    end # if-elsif-else
  end # method serializable_relations

  def serialize_errors resource, **options
    resource.errors.full_messages
  end # method serialize_errors

  def serialize_relation relation, relation_name, relation_params, relations:, **options
    if relation_params[:plurality] == :one
      return nil if relation.nil?

      serializer = decorator_class(relation, 'Serializer')
      serializer.serialize(relation, :relations => relations, **options)
    else
      return [] if relation.empty?

      relation.map do |obj|
        serializer = decorator_class(obj, 'Serializer')
        serializer.serialize(obj, :relations => relations, **options)
      end # map
    end # if-else
  end # method serialize_relation

  def serialize_relations resource, relations:, **options
    serializable_relations(:relations => relations, **options).each.with_object({}) do |(relation_name, relation_params), hsh|
      relation = resource.send(relation_name)

      hsh[relation_name.to_s] = serialize_relation(relation, relation_name, relation_params, :relations => relations, **options)
    end # each
  end # method serialize_relations
end # class
