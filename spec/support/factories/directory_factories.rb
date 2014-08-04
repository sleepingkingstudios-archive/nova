# spec/support/factories/directory_factories.rb

FactoryGirl.define do
  factory :directory do
    sequence(:title) { |index| "Directory #{index}" }
  end # factory
end # define
