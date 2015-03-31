# spec/validators/many_relation_validator_spec.rb

require 'rails_helper'
require 'validators/many_relation_validator'

RSpec.describe ManyRelationValidator do
  before(:all) do
    namespace = defined?(Spec::Models) ? Spec::Models : Spec.const_set(:Models, Module.new)

    namespace.const_set :Book,    Class.new
    namespace.const_set :Chapter, Class.new

    namespace::Book.instance_eval do
      include Mongoid::Document

      embeds_many :chapters, :class_name => "Spec::Models::Chapter"
    end # class

    namespace::Chapter.instance_eval do
      include Mongoid::Document

      embedded_in :book, :class_name => "Spec::Models::Book"
    end # class
  end # before all

  after(:all) do
    namespace = Spec::Models

    namespace.remove_const(:Book)
    namespace.remove_const(:Chapter)
  end # after all

  let(:instance) { }
end # describe
