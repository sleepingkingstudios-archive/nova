# spec/support/factories/features/page_factories.rb

FactoryGirl.define do
  factory :page, :class => 'Page', :parent => :feature do
    sequence(:title) { |index| "Page #{index}" }
  end # factory
end # define
