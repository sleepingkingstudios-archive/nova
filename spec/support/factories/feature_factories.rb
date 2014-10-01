# spec/support/factories/feature_factories.rb

FactoryGirl.define do
  factory :feature do
    sequence(:title) { |index| "Feature #{index}" }
  end # factory
end # define
