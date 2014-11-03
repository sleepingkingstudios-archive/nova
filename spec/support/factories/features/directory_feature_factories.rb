# spec/support/factories/features/directory_feature_factories.rb

FactoryGirl.define do
  factory :directory_feature, :class => 'DirectoryFeature', :parent => :feature do
    sequence(:title) { |index| "Directory Feature #{index}" }
  end # factory
end # define
