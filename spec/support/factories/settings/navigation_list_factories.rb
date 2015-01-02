# spec/support/factories/settings/navigation_list_factories.rb

FactoryGirl.define do
  factory :navigation_list do

  end # factory

  factory :navigation_list_item do
    sequence(:label) { |index| "Navigation Item #{index}" }
  end # factory
end # define
