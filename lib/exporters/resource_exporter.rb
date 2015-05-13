# lib/exporters/resource_exporter.rb

require 'exporters/exporter'

class ResourceExporter < Exporter
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

  include DecoratorsHelper
  include ResourceExporter::DSL::Attributes
  include ResourceExporter::DSL::Relations

  class << self
    attr_accessor :resource_class

    protected

    attr_writer :resource_class

    private

    def inherited subclass
      super

      class_name = (subclass.name || '').sub(/Exporter/, '')
      subclass.resource_class = class_name.constantize
    rescue NameError => exception
      subclass.resource_class = self.resource_class
    end # method inherited

    def persist_resource resource
      instance.send :persist_resource, resource
    end # method persist_resource
  end # eigenclass

  def deserialize attributes, persist: false, **options
    attributes = attributes.stringify_keys
    resource   = resource_class.new attributes.slice(*permitted_attributes)

    # Deserialize relations.
    embedded_relations = permitted_relations.select { |_, hsh| hsh[:embedded] == true }
    attributes.slice(*permitted_relations.keys).each do |relation_name, relation_attributes|
      deserialize_relation(resource, relation_name, relation_attributes, :persist => false)
    end # each

    # Persist resource, if applicable.
    persist_resource(resource) if persist

    resource
  end # method deserialize

  def serialize resource, relations: :embedded, **options
    hsh = resource.attributes.slice(*permitted_attributes)

    if !relations || relations == :none
      relations = []
    elsif relations == :embedded
      relations = permitted_relations.select { |_, hsh| hsh[:embedded] == true }
    else
      relations = permitted_relations
    end # if-elsif-else

    relations.each do |relation_name, relation_params|
      relation = resource.send(relation_name)

      hsh[relation_name.to_s] = serialize_relation(relation, relation_name, relation_params, :relations => relations)
    end # each

    hsh
  end # method serialize

  private

  def deserialize_relation resource, relation_name, attributes, persist: false
    relation_params = permitted_relations[relation_name]

    if relation_params[:plurality] == :one
      attributes = attributes.stringify_keys
      exporter   = decorator_class(attributes.fetch('_type'), 'Exporter')

      resource.send :"#{relation_name}=", exporter.deserialize(attributes, :persist => persist)
    else
      exporter = decorator_class(attributes.first.stringify_keys.fetch('_type'), 'Exporter')
      relation = resource.send(relation_name)

      attributes.each { |hsh| relation << exporter.deserialize(hsh, :persist => persist) }
    end # if-else
  end # method deserialize_relation

  def persist_relation relation, relation_name, relation_params
    if relation_params[:plurality] == :one
      exporter = decorator_class(relation, 'Exporter')
      exporter.send :persist_resource, relation
    else
      exporter = decorator_class(relation.first, 'Exporter')
      relation.each { |obj| exporter.send :persist_resource, obj }
    end # if-else
  end # method persist_relation

  def persist_resource resource
    resource.save!

    referenced_relations = permitted_relations.select { |_, hsh| hsh[:embedded] == false }
    referenced_relations.each do |relation_name, relation_params|
      relation = resource.send relation_name

      persist_relation(relation, relation_name, relation_params)
    end # each
  end # method persist_resource

  def resource_class
    self.class.resource_class
  end # method resource_class

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
end # class
