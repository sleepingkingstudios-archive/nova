# spec/support/factories/example_feature_factories.rb

FactoryGirl.define do
  factory :example_feature, :class => 'Spec::Models::ExampleFeature' do
    example_field "Example Value"
  end # factory
end # define
