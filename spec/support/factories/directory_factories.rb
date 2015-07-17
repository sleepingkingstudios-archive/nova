# spec/support/factories/directory_factories.rb

FactoryGirl.define do
  factory :root_directory do
    initialize_with { RootDirectory.instance }
  end # factory

  factory :directory do
    sequence(:title) { |index| "Directory #{index}" }
  end # factory
end # define
